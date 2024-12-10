# == Schema Information
#
# Table name: shipments
#
#  id                              :bigint           not null, primary key
#  order_id                        :bigint           not null
#  customer_international_shipping :decimal(, )
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  cpass_trade_id                  :integer
#
class Shipment < ApplicationRecord
  belongs_to :order
end
