FactoryBot.define do
  factory :expense do
    year { Time.current.year }
    month { rand(1..12) }
    item_name { Faker::Commerce.product_name }
    amount { Faker::Commerce.price(range: 1000..100000) }
  end
end
