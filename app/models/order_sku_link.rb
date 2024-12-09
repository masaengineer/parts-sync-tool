class OrderSkuLink < ApplicationRecord
  belongs_to :order
  belongs_to :sku
end
