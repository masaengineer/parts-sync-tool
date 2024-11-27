class Sku < ApplicationRecord
  has_many :sku_part_number_links
  has_many :products, through: :sku_part_number_links
  has_many :order_items
end
