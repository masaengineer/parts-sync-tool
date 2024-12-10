class PaymentFee < ApplicationRecord
  belongs_to :order, foreign_key: :order_id

  validates :fee_amount, presence: true, numericality: true
  validates :fee_category, presence: true

  scope :by_category, ->(category) { where(fee_category: category) }
end
