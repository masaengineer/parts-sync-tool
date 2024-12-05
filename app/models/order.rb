class Order < ApplicationRecord
  has_many :order_sku_links, dependent: :destroy
  has_many :skus, through: :order_sku_links
  has_many :sales
  has_many :shipments
  has_many :payment_fees

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
      sale = sales.find_by(order_id: id)
      sku = item.sku
      product = sku.products.first
      procurement = sku.procurements.first

      {
        order_number: order_number,
        order_date: created_at,
        sku: sku.sku_code,
        quantity: sku.quantity,
        product_number: product&.oem_part_number,
        maker: product&.manufacturer&.name,
        product_name: product&.international_title,
        order_net_amount: sale&.order_net_amount,
        sku_net_amount: sku.sku_net_amount,
        product_cost_price: procurement&.purchase_price,
        forwarding_fee: procurement&.forwarding_fee,
        photo_fee: procurement&.photo_fee,
        order_net_profit: calculate_profit(sale&.order_net_amount, sku.sku_net_amount),
        order_net_profit_rate: calculate_profit_rate(sale&.order_net_amount, sku.sku_net_amount),
        sale_id: sale&.id,
        procurement_id: procurement&.id
      }
    end
  end

  private

  def calculate_profit(net_selling_price, unit_cost_price)
    return 0 if net_selling_price.nil? || unit_cost_price.nil?
    net_selling_price.to_f - unit_cost_price.to_f
  end

  def calculate_profit_rate(net_selling_price, unit_cost_price)
    return 0 if net_selling_price.nil? || unit_cost_price.nil? || net_selling_price.to_f.zero?
    ((calculate_profit(net_selling_price, unit_cost_price) / net_selling_price.to_f) * 100).round(2)
  end
end

