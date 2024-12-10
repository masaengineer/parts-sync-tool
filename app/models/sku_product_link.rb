# == Schema Information
#
# Table name: sku_product_links
#
#  id         :bigint           not null, primary key
#  sku_id     :bigint           not null
#  product_id :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class SkuProductLink < ApplicationRecord
  belongs_to :sku
  belongs_to :product

  validates :sku_id, presence: true
  validates :product_id, presence: true
end
