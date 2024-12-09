class Product < ApplicationRecord
  belongs_to :manufacturer

  has_many :sku_product_links
  has_many :skus, through: :sku_product_links

  has_many :procurements

  validates :oem_part_number, presence: true
end
