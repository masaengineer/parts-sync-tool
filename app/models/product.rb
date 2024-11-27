class Product < ApplicationRecord
  belongs_to :product_categories
  has_many :sku_part_number_links
  has_many :skus, through: :sku_part_number_links
  has_many :inventories
  has_many :quotation_items

  validates :oem_part_number, presence: true
  validates :product_status, presence: true
end
