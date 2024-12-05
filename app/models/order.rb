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
      :order_sku_links,
      order_sku_links: { sku: { sku_product_links: :product } }
    ).flat_map do |order|
      order.format_report_data
    end
  end

  def format_report_data
    order_sku_links.map do |item|
      sale = sales.find_by(order_id: id)
      product = item.sku.products.first

      {
        order_number: order_number,
        order_date: created_at,
        sku: item.sku.sku_code,
        quantity: item.quantity,
        product_number: product&.oem_part_number,
        maker: product&.manufacturer&.name,
        product_name: product&.international_title,
        order_net_price: sale&.order_net_amount,
        sku_net_price: item.sku_net_amount,
        product_cost_price: item.procurement_price,
        profit: calculate_profit(sale&.order_net_amount, item.sku_net_amount),
        profit_rate: calculate_profit_rate(sale&.order_net_amount, item.sku_net_amount),
        sale_id: sale&.id,
        procurement_id: item.procurement_id
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

