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
#  sku_id         :bigint
#
# Indexes
#
#  index_procurements_on_sku_id  (sku_id)
#
# Foreign Keys
#
#  fk_rails_...  (sku_id => skus.id)
#
FactoryBot.define do
  factory :procurement do
    
  end
end
