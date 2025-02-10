# == Schema Information
#
# Table name: order_lines
#
#  id             :bigint           not null, primary key
#  seller_sku_id  :bigint           not null
#  quantity       :integer
#  unit_price     :decimal(, )
#  line_item_id   :integer
#  line_item_name :string
#  order_id       :bigint           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
FactoryBot.define do
  factory :order_line do
    seller_sku { nil }
    quantity { 1 }
    unit_price { "9.99" }
    line_item_id { 1 }
    line_item_name { "MyString" }
    order { nil }
  end
end
