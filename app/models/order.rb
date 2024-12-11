# == Schema Information
#
# Table name: orders
#
#  id           :bigint           not null, primary key
#  order_number :string
#  sale_date    :date
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_orders_on_order_number  (order_number)
#
class Order < ApplicationRecord
  has_many :order_sku_links, dependent: :destroy
  has_many :skus, through: :order_sku_links
  has_many :payment_fees, dependent: :destroy
  has_one :sale
  has_one :shipment

  validates :order_number, presence: true
  validates :sale_date, presence: true
end
