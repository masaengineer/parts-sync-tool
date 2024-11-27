class QuotationItem < ApplicationRecord
  belongs_to :quotation
  belongs_to :product
end
