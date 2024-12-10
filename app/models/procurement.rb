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
class Procurement < ApplicationRecord
  belongs_to :sku

  validates :purchase_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :forwarding_fee, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :photo_fee, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :sku_id, presence: true
end
