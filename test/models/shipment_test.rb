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
require "test_helper"

class ShipmentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
