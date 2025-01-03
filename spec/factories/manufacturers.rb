FactoryBot.define do
  factory :manufacturer do
    name { Faker::Company.name }

    trait :with_skus do
      after(:create) do |manufacturer|
        create_list(:sku, 3, manufacturer: manufacturer)
      end
    end
  end
end
