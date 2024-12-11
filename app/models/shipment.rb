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
#
# Indexes
#
#  index_shipments_on_order_id  (order_id)
#
class Shipment < ApplicationRecord
  belongs_to :order
end

