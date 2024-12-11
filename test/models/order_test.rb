# == Schema Information
#
# Table name: orders
#
#  id           :bigint           not null, primary key
#  order_number :string
#  sale_date    :date
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_orders_on_order_number  (order_number)
#
require "test_helper"

class OrderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
