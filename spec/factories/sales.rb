FactoryBot.define do
  factory :sale do
    order_net_amount { Faker::Commerce.price(range: 10000..100000) }
    order_gross_amount { order_net_amount * 1.1 }  # 税込み金額を想定
    association :order
  end
end
