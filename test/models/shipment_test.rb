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
#  tracking_number                 :string
#
# Indexes
#
#  index_shipments_on_order_id  (order_id)
#
require "test_helper"

class ShipmentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
