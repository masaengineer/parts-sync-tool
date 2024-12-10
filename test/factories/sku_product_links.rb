# == Schema Information
#
# Table name: sku_product_links
#
#  id         :bigint           not null, primary key
#  sku_id     :bigint           not null
#  product_id :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :sku_product_link do
    
  end
end
