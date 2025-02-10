class SkuMapping < ApplicationRecord
  belongs_to :seller_sku
  belongs_to :manufacturer_sku

  validates :seller_sku_id, uniqueness: { scope: :manufacturer_sku_id }
end
