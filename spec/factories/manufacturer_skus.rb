FactoryBot.define do
  factory :manufacturer_sku do
    sku_code { "MyString" }
    manufacturer { nil }
  end
end
