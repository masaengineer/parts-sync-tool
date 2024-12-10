# == Schema Information
#
# Table name: skus
#
#  id               :bigint           not null, primary key
#  sku_code         :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  quantity         :integer
#  sku_net_amount   :decimal(10, 2)
#  sku_gross_amount :decimal(10, 2)
#
require "test_helper"

class SkuTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
