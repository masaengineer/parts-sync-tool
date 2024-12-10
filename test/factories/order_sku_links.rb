# == Schema Information
#
# Table name: order_sku_links
#
#  id         :bigint           not null, primary key
#  order_id   :bigint           not null
#  sku_id     :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :order_sku_link do
    
  end
end
