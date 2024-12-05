FactoryBot.define do
  factory :payment_fee do
    order { nil }
    fee_category { "MyString" }
    fee_amount { "9.99" }
  end
end
