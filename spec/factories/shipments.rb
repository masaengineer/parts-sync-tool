# == Schema Information
#
# Table name: shipments
#
#  id                              :bigint           not null, primary key
#  customer_international_shipping :decimal(, )
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  cpass_trade_id                  :integer
#  order_id                        :bigint
#  tracking_number                 :string
#
# Indexes
#
#  index_shipments_on_order_id  (order_id)
#
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
