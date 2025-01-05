# == Schema Information
#
# Table name: sales
#
#  id                 :bigint           not null, primary key
#  order_id           :bigint           not null
#  order_net_amount   :decimal(, )
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  order_gross_amount :decimal(, )
#
# Indexes
#
#  index_sales_on_order_id  (order_id)
#
# Foreign Keys
#
#  fk_rails_...  (order_id => orders.id)
#
FactoryBot.define do
  factory :sale do
    order_net_amount { Faker::Commerce.price(range: 10000..100000) }
    order_gross_amount { order_net_amount * 1.1 }  # 税込み金額を想定
    association :order
  end
end
