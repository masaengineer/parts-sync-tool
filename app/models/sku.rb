# == Schema Information
#
# Table name: skus
#
#  id               :bigint           not null, primary key
#  sku_code         :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  quantity         :integer
#  sku_net_amount   :decimal(10, 2)
#  sku_gross_amount :decimal(10, 2)
#
# Indexes
#
#  index_skus_on_sku_code          (sku_code)
#  index_skus_on_sku_gross_amount  (sku_gross_amount)
#  index_skus_on_sku_net_amount    (sku_net_amount)
#
class Sku < ApplicationRecord
  has_many :order_sku_links
  has_many :orders, through: :order_sku_links
  has_many :sku_product_links
  has_many :products, through: :sku_product_links
  has_many :procurements

  validates :sku_code, presence: true, uniqueness: true

  def self.ransackable_attributes(auth_object = nil)
    %w[
      sku_code
      quantity
      sku_net_amount
      sku_gross_amount
      created_at
      updated_at
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[order_sku_links orders procurements sku_product_links products]
  end
end
