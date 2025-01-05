# == Schema Information
#
# Table name: orders
#
#  id           :bigint           not null, primary key
#  order_number :string
#  sale_date    :date
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_orders_on_order_number  (order_number)
#  index_orders_on_user_id       (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :order do
    order_number { "ORD-#{Faker::Number.unique.number(digits: 8)}" }
    sale_date { Faker::Date.backward(days: 30) }
    association :user

    trait :with_skus do
      after(:create) do |order|
        create_list(:order_sku_link, 2, order: order)
      end
    end

    trait :with_procurement do
      after(:create) do |order|
        create(:procurement, order: order)
      end
    end

    trait :with_shipment do
      after(:create) do |order|
        create(:shipment, order: order)
      end
    end
  end
end
