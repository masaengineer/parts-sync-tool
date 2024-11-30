class Product < ApplicationRecord
  belongs_to :manufacturer
  belongs_to :product_category, foreign_key: 'product_categories_id'

  has_many :sku_product_links
  has_many :skus, through: :sku_product_links

  has_many :inventories
  has_many :procurements

  validates :oem_part_number, presence: true
end
