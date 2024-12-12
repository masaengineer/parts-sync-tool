# == Schema Information
#
# Table name: order_sku_links
#
#  id         :bigint           not null, primary key
#  order_id   :bigint           not null
#  sku_id     :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_order_sku_links_on_order_id             (order_id)
#  index_order_sku_links_on_order_id_and_sku_id  (order_id,sku_id) UNIQUE
#  index_order_sku_links_on_sku_id               (sku_id)
#
# Foreign Keys
#
#  fk_rails_...  (order_id => orders.id)
#  fk_rails_...  (sku_id => skus.id)
#
class OrderSkuLink < ApplicationRecord
  belongs_to :order
  belongs_to :sku

  def self.ransackable_attributes(auth_object = nil)
    %w[
      created_at
      updated_at
      order_id
      sku_id
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[order sku]
  end
end
