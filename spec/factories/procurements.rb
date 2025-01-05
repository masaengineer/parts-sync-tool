# == Schema Information
#
# Table name: procurements
#
#  id             :bigint           not null, primary key
#  purchase_price :decimal(, )
#  forwarding_fee :decimal(, )
#  photo_fee      :decimal(, )
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  order_id       :bigint           not null
#  handling_fee   :decimal(10, 2)
#
# Indexes
#
#  index_procurements_on_order_id  (order_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (order_id => orders.id)
#
FactoryBot.define do
  factory :procurement do
    purchase_price { Faker::Commerce.price(range: 5000..50000) }
    forwarding_fee { Faker::Commerce.price(range: 500..2000) }
    photo_fee { Faker::Commerce.price(range: 100..500) }
    handling_fee { Faker::Commerce.price(range: 300..1000) }
    association :order
  end
end
