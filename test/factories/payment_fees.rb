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
FactoryBot.define do
  factory :payment_fee do
    order { nil }
    fee_category { "MyString" }
    fee_amount { "9.99" }
  end
end
