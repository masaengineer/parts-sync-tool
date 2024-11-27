class QuotationItem < ApplicationRecord
  belongs_to :quotation
  belongs_to :product
  has_many :quotation_item_changes
end
