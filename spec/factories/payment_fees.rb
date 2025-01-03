FactoryBot.define do
  factory :payment_fee do
    fee_amount { Faker::Commerce.price(range: 100..1000) }
    fee_category { ['クレジットカード手数料', '銀行振込手数料', 'PayPal手数料'].sample }
    association :order
  end
end
