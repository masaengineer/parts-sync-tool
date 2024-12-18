require 'csv'

class FinancialReportImporter
  PROMOTED_LISTING_DESCRIPTION = "Promoted Listings - General fee "
  FEE_CATEGORIES = ["Final Value Fee - fixed", "Final Value Fee - variable", "International fee"]

  def initialize(csv_path)
    @csv_path = csv_path
  end

  def import
    all_lines = File.read(@csv_path).lines
    # ヘッダー行は11行スキップして12行目をヘッダーとする
    # 0-based indexで11がヘッダー行インデックス
    header_line_index = 11
    header = all_lines[header_line_index].strip.split(",")
    data_lines = all_lines[(header_line_index+1)..]

    csv = CSV.new(data_lines.join, headers: header, return_headers: false)
    rows_by_order = Hash.new { |h,k| h[k] = [] }

    csv.each do |row|
      order_number = row["Order number"]&.strip
      next if order_number.nil? || order_number.empty?
      rows_by_order[order_number] << row
    end

    rows_by_order.each do |order_number, rows|
      process_order_rows(order_number, rows)
    end
  end

  private

  def process_order_rows(order_number, rows)
    # Order取得または作成(新規作成方針)
    order = Order.find_or_create_by!(order_number: order_number)

    # sale_date取得: "Transaction creation date"カラムから変換（適宜フォーマットに応じてDate.parseなど）
    # 最初の行からとる（本来はアグリゲータ行、もしくはType=Order行から取得）
    # CSVの日付形式に応じて変換例: Date.parse(row["Transaction creation date"])
    aggregator_line = rows.find { |r| r["Type"]&.strip == "Order" && !to_decimal(r["Net amount"]).nil? && !to_decimal(r["Gross transaction amount"]).nil? }

    # アグリゲータ行がない場合は単品かもしれない
    # もしくはType=Order行が1つしかない場合はそれが単品注文扱い
    order_lines = rows.select { |r| r["Type"]&.strip == "Order" }
    other_fee_lines = rows.select { |r| r["Type"]&.strip == "Other fee" }

    if order_lines.size == 1
      # 単一商品販売
      line = order_lines.first
      order.sale_date = to_date(line["Transaction creation date"])
      order.save!

      net_amount = to_decimal(line["Net amount"])
      gross_amount = to_decimal(line["Gross transaction amount"])

      # Sales登録
      sale = Sale.find_or_initialize_by(order_id: order.id)
      sale.order_net_amount = net_amount if net_amount
      sale.order_gross_amount = gross_amount if gross_amount
      sale.save!

      # SKU作成または取得: Custom labelがSKUコードと仮定
      sku_code = line["Custom label"]&.strip
      sku = Sku.find_or_initialize_by(sku_code: sku_code)
      # 新規SKUの場合他の値設定
      sku.quantity = line["Quantity"]&.to_i if line["Quantity"]
      sku.international_title = line["Item title"]&.strip
      sku.sku_net_amount = net_amount if net_amount
      sku.sku_gross_amount = gross_amount if gross_amount
      sku.save!

      # Order-SKU link
      OrderSkuLink.find_or_create_by!(order_id: order.id, sku_id: sku.id)

      # 手数料(FEE_CATEGORIES)
      FEE_CATEGORIES.each do |cat|
        amount = to_decimal(line[cat])
        if amount && amount != 0
          PaymentFee.create!(
            order_id: order.id,
            fee_category: cat,
            fee_amount: amount
          )
        end
      end

    else
      # 複数商品販売
      # アグリゲータ行が存在する前提(なければロジック要検討)
      aggregator_line ||= order_lines.first # 万が一なければ最初のorder行をaggregatorとみなす
      order.sale_date = to_date(aggregator_line["Transaction creation date"])
      order.save!

      net_amount = to_decimal(aggregator_line["Net amount"])
      gross_amount = to_decimal(aggregator_line["Gross transaction amount"])

      # Sales登録
      sale = Sale.find_or_initialize_by(order_id: order.id)
      sale.order_net_amount = net_amount if net_amount
      sale.order_gross_amount = gross_amount if gross_amount
      sale.save!

      # aggregator以外のOrder行はSKU単位行とみなす
      sku_item_lines = order_lines.reject { |r| r.equal?(aggregator_line) }

      sku_item_lines.each do |sku_line|
        # SKU行はItem subtotalがsku_gross_amount相当
        item_subtotal = to_decimal(sku_line["Item subtotal"])

        # 該当行の手数料抽出
        fv_fixed = to_decimal(sku_line["Final Value Fee - fixed"]) || 0
        fv_variable = to_decimal(sku_line["Final Value Fee - variable"]) || 0
        international_fee = to_decimal(sku_line["International fee"]) || 0

        sku_net = item_subtotal - (fv_fixed + fv_variable + international_fee)

        # SKU作成または取得
        sku_code = sku_line["Custom label"]&.strip
        sku = Sku.find_or_initialize_by(sku_code: sku_code)
        sku.quantity = sku_line["Quantity"]&.to_i if sku_line["Quantity"]
        sku.international_title = sku_line["Item title"]&.strip
        sku.sku_net_amount = sku_net
        sku.sku_gross_amount = item_subtotal
        sku.save!

        # Order-SKU link
        OrderSkuLink.find_or_create_by!(order_id: order.id, sku_id: sku.id)
      end

      # アグリゲータ行から手数料抽出
      FEE_CATEGORIES.each do |cat|
        amount = to_decimal(aggregator_line[cat])
        if amount && amount != 0
          PaymentFee.create!(
            order_id: order.id,
            fee_category: cat,
            fee_amount: amount
          )
        end
      end
    end

    # Other fee行 (Promoted Listing)
    other_fee_lines.each do |fee_line|
      description = fee_line["Description"]&.strip
      if description == PROMOTED_LISTING_DESCRIPTION
        pl_net = to_decimal(fee_line["Net amount"])
        PaymentFee.create!(
          order_id: order.id,
          fee_category: "Promoted Listings - General fee",
          fee_amount: pl_net&.abs
        )
      end
    end
  end

  def to_decimal(value)
    return nil if value.nil? || value.strip.empty?
    BigDecimal(value)
  rescue ArgumentError
    nil
  end

  def to_date(value)
    return nil if value.nil? || value.strip.empty?
    # CSV上の日付フォーマットに応じて変換
    Date.parse(value) rescue nil
  end
end
