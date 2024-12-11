# == Schema Information
#
# Table name: payment_fees
#
#  id           :bigint           not null, primary key
#  order_id     :bigint           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  fee_category :string
#  fee_amount   :decimal(, )
#
# Indexes
#
#  index_payment_fees_on_order_id  (order_id)
#
# Foreign Keys
#
#  fk_rails_...  (order_id => orders.id)
#
require "test_helper"

class PaymentFeeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
