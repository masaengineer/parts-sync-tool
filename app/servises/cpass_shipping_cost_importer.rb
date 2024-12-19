# app/services/cpass_shipping_cost_importer.rb
require 'csv'

class CpassShippingCostImporter
  class PositiveDiscountError < StandardError; end

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
  rescue PositiveDiscountError => e
    # 呼び出し元で処理できるようにエラーを再度raise
    # ここでログ出力などを行ってもよい
    raise e
  end

  private

  def import_row(row)
    tracking_number = row["注文番号"]&.strip
    return if tracking_number.blank?

    discount_value = to_decimal(row["還元金額（円）"])

    shipping_cost =
      if discount_value < 0
        # 還元金額がマイナス → C列を使用
        to_decimal(row["金額（円）"])
      elsif discount_value == 0
        # 還元金額が0 → D列を使用
        to_decimal(row["ご請求金額（円）"])
      else
        # 還元金額がプラス → エラー発生
        raise PositiveDiscountError, "Positive discount encountered for tracking_number: #{tracking_number}"
      end

    shipment = Shipment.find_or_create_by!(tracking_number: tracking_number)
    shipment.update!(customer_international_shipping: shipping_cost)
  end

  def to_decimal(value)
    return nil if value.nil? || value.strip.empty?
    cleaned = value.gsub(/["’,]/, "") # カンマやクォートを除去
    BigDecimal(cleaned)
  rescue ArgumentError
    nil
  end
end
