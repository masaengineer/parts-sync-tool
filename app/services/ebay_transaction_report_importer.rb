require "csv"

class EbayTransactionReportImporter
  include ExchangeRateConcern

  # eBay取引レポート用インポータ
  #
  # このクラスはebay_transaction_report.csvを読み込み、CSV内の"Type"が"Order"になっている行をもとに
  # 注文(Order)や手数料(PaymentFee)等を登録・更新する。
  #
  # 前提:
  # - CSVファイルには11行のヘッダ部分があり、12行目から実データヘッダ
  # - "Order number"が注文を特定するキー
  # - "Type"カラムで"Order"行が注文の中心データとなる
  #
  # 主な処理:
  # 1. CSVファイルを読み込み、ヘッダーとデータ行を抽出
  # 2. Order numberごとに行をグループ化
  # 3. 各注文ごとにprocess_order_rowsメソッドで処理
  #

  PROMOTED_LISTING_DESCRIPTION = "Promoted Listings - General fee "
  FEE_CATEGORIES = [ "Final Value Fee - fixed", "Final Value Fee - variable", "International fee" ]

  def initialize(csv_path, user)
    @csv_path = csv_path
    @user = user
  end

  def import
    lines = read_file_lines(@csv_path)
    return if lines.empty?

    header_line_index = 11
    return if lines.length <= header_line_index

    header = lines[header_line_index].to_s.strip.split(",")
    return if header.empty?

    data_lines = lines[(header_line_index+1)..]
    return if data_lines.nil? || data_lines.empty?

    csv = CSV.new(data_lines.join, headers: header, return_headers: false)
    rows_by_order = group_rows_by_order_number(csv)

    rows_by_order.each do |order_number, rows|
      process_order_rows(order_number, rows)
    end
  rescue StandardError => e
    Rails.logger.error "eBay取引レポートインポート中にエラー: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    raise "CSVファイルの処理中にエラーが発生しました: #{e.message}"
  end

  private

  # ファイル内容を行単位で読み込み
  def read_file_lines(path)
    File.read(path).lines
  end

  # CSVをOrder number単位でハッシュ化
  def group_rows_by_order_number(csv)
    result = Hash.new { |h, k| h[k] = [] }
    csv.each do |row|
      next if row.nil?
      order_number = row["Order number"]&.strip
      next if order_number.nil? || order_number.empty?
      result[order_number] << row
    end
    result
  end

  # 各注文(order_number)の行を処理
  def process_order_rows(order_number, rows)
    # "Order"行を先に抽出
    order_lines = rows.select { |r| r["Type"]&.strip == "Order" }
    if order_lines.empty?
      # "Order"行がない場合は新規作成せずログに警告だけ出して終了
      Rails.logger.warn "Order行が見つかりません: OrderNumber=#{order_number}"
      return
    end

    # "Order"行がある場合のみ、新規作成 or 取得
    order = @user.orders.find_or_create_by!(order_number: order_number)

    aggregator_line = find_aggregator_line(order_lines)
    unless aggregator_line
      # aggregator_lineが見つからない場合は処理スキップ
      Rails.logger.warn "aggregator_lineが見つかりません: OrderNumber=#{order_number}"
      return
    end

    # 販売日を設定
    sale_date = to_date(aggregator_line["Transaction creation date"])
    order.sale_date = sale_date if sale_date
    order.save!

    # SKUや手数料の登録
    handle_order_lines(order, order_lines, aggregator_line)
    handle_other_fee_lines(order, rows)
    handle_shipping_label_lines(order, rows)
  end

  # aggregator_lineを特定
  # - "Order" TypeでNet amountとGross transaction amountがある行を探す
  def find_aggregator_line(order_lines)
    line = order_lines.find { |r|
      r["Type"]&.strip == "Order" &&
      !to_decimal(r["Net amount"]).nil? &&
      !to_decimal(r["Gross transaction amount"]).nil?
    }
    line || order_lines.first
  end

  # SKUやSale、PaymentFeeなどの登録
  def handle_order_lines(order, order_lines, aggregator_line)
    if order_lines.size == 1
      # 単一商品販売
      line = order_lines.first
      process_single_item_order(order, line)
    else
      # 複数商品販売
      process_multi_item_order(order, order_lines, aggregator_line)
    end
  end

  # 単一SKUオーダー処理
  def process_single_item_order(order, line)
    net_amount = to_decimal(line["Net amount"])
    gross_amount = to_decimal(line["Gross transaction amount"])

    # Sales登録
    sale = Sale.find_or_initialize_by(order_id: order.id)
    sale.order_net_amount = net_amount if net_amount
    sale.order_gross_amount = gross_amount if gross_amount
    sale.save!

    # SKU登録
    sku_code = line["Custom label"]&.strip
    sku = find_or_create_sku(sku_code, line)
    OrderSkuLink.find_or_create_by!(order_id: order.id, sku_id: sku.id)

    # 手数料登録
    register_fees(order, line)
  end

  # 複数SKUオーダー処理
  def process_multi_item_order(order, order_lines, aggregator_line)
    net_amount = to_decimal(aggregator_line["Net amount"])
    gross_amount = to_decimal(aggregator_line["Gross transaction amount"])

    sale = Sale.find_or_initialize_by(order_id: order.id)
    sale.order_net_amount = net_amount if net_amount
    sale.order_gross_amount = gross_amount if gross_amount
    sale.save!

    sku_item_lines = order_lines.reject { |r| r.equal?(aggregator_line) }
    sku_item_lines.each do |sku_line|
      # SKUごとの処理
      item_subtotal = to_decimal(sku_line["Item subtotal"])
      fv_fixed = (to_decimal(sku_line["Final Value Fee - fixed"]) || 0).abs
      fv_var = (to_decimal(sku_line["Final Value Fee - variable"]) || 0).abs
      intl_fee = (to_decimal(sku_line["International fee"]) || 0).abs

      sku_net = item_subtotal - (fv_fixed + fv_var + intl_fee)
      sku_code = sku_line["Custom label"]&.strip
      sku = find_or_create_sku(sku_code, sku_line, sku_net, item_subtotal)
      OrderSkuLink.find_or_create_by!(order_id: order.id, sku_id: sku.id)
    end

    # aggregator行から手数料登録
    register_fees(order, aggregator_line)
  end

  # Other fee行処理（Promoted Lisltingsなど）
  def handle_other_fee_lines(order, rows)
    other_fee_lines = rows.select { |r| r["Type"]&.strip == "Other fee" }
    other_fee_lines.each do |fee_line|
      description = fee_line["Description"]&.strip
      if description == PROMOTED_LISTING_DESCRIPTION
        pl_net = to_decimal(fee_line["Net amount"])
        if pl_net && pl_net != 0
          PaymentFee.create!(
            order_id: order.id,
            fee_category: "Promoted Listings - General fee",
            fee_amount: pl_net.abs
          )
        end
      end
    end
  end

  # Shipping label行処理
  # - Typeが"Shipping label"の行について、Net amountの絶対値をShipment.customer_international_shippingに登録する
  # - Net amountはUSDなので、JPYに変換して保存する
  # - Reference IDから追跡番号を抽出し、tracking_numberとして保存する
  def handle_shipping_label_lines(order, rows)
    shipping_label_lines = rows.select { |r| r["Type"]&.strip == "Shipping label" }
    shipping_label_lines.each do |lbl_line|
      net = to_decimal(lbl_line["Net amount"])
      next if net.nil? || net == 0

      # USDからJPYに変換
      net_jpy = convert_usd_to_jpy(net)

      # 追跡番号を取得（Reference IDから数字のみを抽出）
      tracking_number = extract_tracking_number(lbl_line["Reference ID"])

      # shipmentの作成または取得
      shipment = order.shipment || order.build_shipment
      shipment.customer_international_shipping = net_jpy
      # 追跡番号を設定（存在する場合のみ）
      shipment.tracking_number = tracking_number if tracking_number.present?
      shipment.save!
    end
  end

  # 追跡番号抽出メソッド
  # @param reference_id [String] Reference ID文字列
  # @return [String, nil] 抽出された追跡番号または nil
  def extract_tracking_number(reference_id)
    return nil if reference_id.blank?

    # 数字のみを抽出（連続する数字の最も長い部分を取得）
    numbers = reference_id.scan(/\d+/)
    numbers.max_by(&:length)
  end

  # SKU作成または取得
  # 単一商品はnet_amount/gross_amountは直接渡せる
  # 複数商品時はitem_subtotalと手数料計算済みsku_netを用いる
  def find_or_create_sku(sku_code, line, sku_net = nil, sku_gross = nil)
    sku = Sku.find_or_initialize_by(sku_code: sku_code)
    if line["Quantity"]
      sku.quantity = line["Quantity"]&.to_i
    end
    sku.international_title = line["Item title"]&.strip
    # sku_net_amount, sku_gross_amountは単一または複数判定で異なる
    if sku_net && sku_gross
      # 複数商品の場合
      sku.sku_net_amount = sku_net
      sku.sku_gross_amount = sku_gross
    else
      # 単一商品の場合
      net_amount = to_decimal(line["Net amount"])
      gross_amount = to_decimal(line["Gross transaction amount"])
      sku.sku_net_amount = net_amount if net_amount
      sku.sku_gross_amount = gross_amount if gross_amount
    end
    sku.save!
    sku
  end

  # 手数料登録
  def register_fees(order, line)
    FEE_CATEGORIES.each do |cat|
      amount = to_decimal(line[cat])
      next if amount.nil? || amount == 0
      PaymentFee.create!(
        order_id: order.id,
        fee_category: cat,
        fee_amount: amount.abs
      )
    end
  end

  # 文字列をBigDecimalに変換
  def to_decimal(value)
    return nil if value.nil? || value.strip.empty?
    BigDecimal(value)
  rescue ArgumentError
    nil
  end

  # 日付変換
  def to_date(value)
    return nil if value.nil? || value.strip.empty?
    Date.parse(value) rescue nil
  end
end
