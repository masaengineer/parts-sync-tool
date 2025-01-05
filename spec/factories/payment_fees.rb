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
FactoryBot.define do
  factory :payment_fee do
    fee_amount { Faker::Commerce.price(range: 100..1000) }
    fee_category { [ 'クレジットカード手数料', '銀行振込手数料', 'PayPal手数料' ].sample }
    association :order
  end
end
