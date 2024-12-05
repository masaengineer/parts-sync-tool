class Sale < ApplicationRecord
  belongs_to :order

  validates :price_original, presence: true, numericality: true
end
