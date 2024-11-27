class ProductCategory < ApplicationRecord
  has_many :products
  belongs_to :parent_category, class_name: 'ProductCategory', optional: true
  has_many :subcategories, class_name: 'ProductCategory', foreign_key: 'parent_category_id'
end
