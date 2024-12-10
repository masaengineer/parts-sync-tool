# == Schema Information
#
# Table name: orders
#
#  id              :bigint           not null, primary key
#  order_number    :string
#  sale_date       :date
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  tracking_number :string
#
class Order < ApplicationRecord
  has_many :order_sku_links, dependent: :destroy
  has_many :skus, through: :order_sku_links
  has_one :sale
  has_one :shipment
  has_one :payment_fee

  validates :order_number, presence: true
  validates :sale_date, presence: true

  def self.report_data
    includes(
      :sales,
      order_sku_links: {
        sku: [
          :procurements,
          { sku_product_links: { product: :manufacturer } }
        ]
      }
    ).flat_map do |order|
      order.format_report_data
    end
  end

  def format_report_data
    order_sku_links.map do |item|
      sale = sales.first
      sku = item.sku
      product = sku&.products&.first
      procurement = sku&.procurements&.first

      dollar_order_net_amount = sale&.order_net_amount.to_f.round(2)
      dollar_sku_net_amount = sku&.sku_net_amount.to_f.round(2)
      dollar_purchase_price = procurement&.purchase_price.to_f.round(2)
      dollar_forwarding_fee = procurement&.forwarding_fee.to_f.round(2)
      dollar_photo_fee = procurement&.photo_fee.to_f.round(2)

      yen_order_net_amount = (dollar_order_net_amount * DOLLAR_TO_YEN_RATE).round
      yen_sku_net_amount = (dollar_sku_net_amount * DOLLAR_TO_YEN_RATE).round
      yen_purchase_price = (dollar_purchase_price * DOLLAR_TO_YEN_RATE).round
      yen_forwarding_fee = (dollar_forwarding_fee * DOLLAR_TO_YEN_RATE).round
      yen_photo_fee = (dollar_photo_fee * DOLLAR_TO_YEN_RATE).round

      {
        order_number: order_number,
        order_date: created_at,
        sku: sku&.sku_code,
        quantity: sku&.quantity.to_i,
        product_number: product&.oem_part_number,
        maker: product&.manufacturer&.name,
        product_name: product&.international_title,
        order_net_amount_usd: dollar_order_net_amount,
        order_net_amount_jpy: yen_order_net_amount,
        sku_net_amount_usd: dollar_sku_net_amount,
        sku_net_amount_jpy: yen_sku_net_amount,
        product_cost_price_usd: dollar_purchase_price,
        product_cost_price_jpy: yen_purchase_price,
        forwarding_fee_usd: dollar_forwarding_fee,
        forwarding_fee_jpy: yen_forwarding_fee,
        photo_fee_usd: dollar_photo_fee,
        photo_fee_jpy: yen_photo_fee,

        order_net_profit_jpy: calculate_profit_in_yen(yen_order_net_amount, sku, procurement),
        order_net_profit_rate: calculate_profit_rate(yen_order_net_amount, sku, procurement),
        sale_id: sale&.id,
        procurement_id: procurement&.id
      }
    end
  end

  def items_count
    order_sku_links.count
  end

  private

  def calculate_profit(net_selling_amount_jpy, current_sku, current_procurement)
    return 0 if net_selling_amount_jpy.nil?

    total_cost = [
      current_sku&.sku_net_amount.to_f,
      current_procurement&.forwarding_fee.to_f,
      current_procurement&.photo_fee.to_f,
      shipments.sum(&:customer_international_shipping).to_f,
      payment_fees.sum(&:fee_amount).to_f
    ].sum

    net_selling_amount_jpy.to_f - total_cost
  end

  def calculate_profit_in_yen(net_selling_amount_jpy, current_sku, current_procurement)
    return 0 if net_selling_amount_jpy.nil?

    total_cost_yen = [
      current_sku&.sku_net_amount.to_f,
      current_procurement&.purchase_price.to_f,
      current_procurement&.forwarding_fee.to_f,
      current_procurement&.photo_fee.to_f,
      shipments.sum(&:customer_international_shipping).to_f,
      payment_fees.sum(&:fee_amount).to_f
    ].sum * DOLLAR_TO_YEN_RATE

    (net_selling_amount_jpy.to_f - total_cost_yen).round
  end

  def calculate_profit_rate(net_selling_amount_jpy, current_sku, current_procurement)
    return 0 if net_selling_amount_jpy.nil? || net_selling_amount_jpy.to_f.zero?

    # yenベースで利益率を計算
    profit_jpy = calculate_profit(net_selling_amount_jpy, current_sku, current_procurement)
    ((profit_jpy / net_selling_amount_jpy.to_f) * 100).round(2)
  end
end
