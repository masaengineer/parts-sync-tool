# == Schema Information
#
# Table name: sales
#
#  id                 :bigint           not null, primary key
#  order_id           :bigint           not null
#  order_net_amount   :decimal(, )
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  order_gross_amount :decimal(, )
#
require "test_helper"

class SaleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
