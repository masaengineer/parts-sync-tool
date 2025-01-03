FactoryBot.define do
  factory :order_sku_link do
    association :order
    association :sku
  end
end
