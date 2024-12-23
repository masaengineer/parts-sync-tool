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

class Order < ApplicationRecord
  has_many :order_sku_links, dependent: :destroy
  has_many :skus, through: :order_sku_links
  has_many :payment_fees, dependent: :destroy
  has_one :procurement, dependent: :destroy
  has_one :sale
  has_one :shipment

  validates :order_number, presence: true, uniqueness: true

  def self.ransackable_attributes(auth_object = nil)
    %w[
      order_number
      sale_date
      created_at
      updated_at
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[sale order_sku_links skus procurement shipment payment_fees]
  end

  # 注文に関連する仕入れコストの合計を計算
  def total_procurement_cost
    procurement&.total_cost || 0
  end
end
