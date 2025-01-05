# == Schema Information
#
# Table name: manufacturers
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_manufacturers_on_name  (name)
#
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
