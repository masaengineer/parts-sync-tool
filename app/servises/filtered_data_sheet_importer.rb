require 'csv'

class FilteredDataSheetImporter
  class MissingSkusError < StandardError; end

  def initialize(csv_path)
    @csv_path = csv_path
  end

  def import
    csv = CSV.read(@csv_path, headers: true)
    ActiveRecord::Base.transaction do
      csv.each do |row|
        import_row(row)
      end
    end
  rescue MissingSkusError => e
    # この例ではraiseされたエラーをキャッチするだけ。
    # コントローラ側でこのエラーをキャッチし、ユーザーにメッセージ表示することも可能。
    raise e
  end

  private

  def import_row(row)
    order_number      = row["order_number"]&.strip
    return if order_number.blank?

    # 該当のOrder取得または作成
    order = Order.find_or_create_by!(order_number: order_number)

    # SKUが一つも紐づいていない場合はエラー発生
    # 事前にebaytransactionreport等でSKU登録が必要
    if order.skus.empty?
      raise MissingSkusError, "Order #{order_number} has no SKUs. Please upload the SKU-related CSV file first."
    end

    # ここに来るということはSKUが存在するはず
    # 以下通常処理（必要に応じてProcurement作成等）：
    manufacturer_name = row["manufacturer_name"]&.strip
    purchase_price    = to_decimal(row["purchase_price"])
    handling_fee      = to_decimal(row["handling_fee"])
    photo_fee         = to_decimal(row["photo_fee"])

    # メーカー登録
    if manufacturer_name.present?
      manufacturer = Manufacturer.find_or_create_by!(name: manufacturer_name)
    else
      manufacturer = Manufacturer.find_or_create_by!(name: "Unknown")
    end

    # ここで、実際にはProcurementを紐づける際にsku_idが必要だが、
    # 既にSKUがあるはずなので例えば最初のSKUを対象とするなどのロジックが可能
    # あるいは注文に紐付いたSKUごとにProcurementを生成するなど。
    # 例として最初のSKUを使う:
    sku = order.skus.first

    procurement = Procurement.find_or_initialize_by(sku_id: sku.id)
    procurement.purchase_price = purchase_price if purchase_price
    procurement.handling_fee   = handling_fee   if handling_fee
    procurement.photo_fee      = photo_fee      if photo_fee
    procurement.save!
  end

  def to_decimal(value)
    return nil if value.nil? || value.strip.empty?
    BigDecimal(value)
  rescue ArgumentError
    nil
  end
end
