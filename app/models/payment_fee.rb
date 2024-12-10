# == Schema Information
#
# Table name: payment_fees
#
#  id           :bigint           not null, primary key
#  order_id     :bigint           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  fee_category :string
#  fee_amount   :decimal(, )
#
# Indexes
#
#  index_payment_fees_on_order_id  (order_id)
#
# Foreign Keys
#
#  fk_rails_...  (order_id => orders.id)
#
class PaymentFee < ApplicationRecord
  belongs_to :order, foreign_key: :order_id

  validates :fee_amount, presence: true, numericality: true
  validates :fee_category, presence: true

  scope :by_category, ->(category) { where(fee_category: category) }
end
