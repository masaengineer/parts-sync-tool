FactoryBot.define do
  factory :procurement do
    purchase_price { Faker::Commerce.price(range: 5000..50000) }
    forwarding_fee { Faker::Commerce.price(range: 500..2000) }
    photo_fee { Faker::Commerce.price(range: 100..500) }
    handling_fee { Faker::Commerce.price(range: 300..1000) }
    association :order
  end
end
