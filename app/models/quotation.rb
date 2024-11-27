class Quotation < ApplicationRecord
  belongs_to :wholesaler
  has_many :quotation_items
end
