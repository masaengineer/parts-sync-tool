FactoryBot.define do
  factory :shipment do
    customer_international_shipping { Faker::Commerce.price(range: 1000..5000) }
    cpass_trade_id { Faker::Number.unique.number(digits: 8) }
    tracking_number { "TN#{Faker::Number.unique.number(digits: 12)}" }
    association :order

    trait :without_order do
      order { nil }
    end
  end
end
