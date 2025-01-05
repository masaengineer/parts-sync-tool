# == Schema Information
#
# Table name: expenses
#
#  id         :bigint           not null, primary key
#  year       :integer
#  month      :integer
#  item_name  :string
#  amount     :decimal(, )
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :expense do
    year { Time.current.year }
    month { rand(1..12) }
    item_name { Faker::Commerce.product_name }
    amount { Faker::Commerce.price(range: 1000..100000) }
  end
end
