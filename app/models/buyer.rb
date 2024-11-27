class Buyer < ApplicationRecord
  belongs_to :address
  has_many :orders
end
