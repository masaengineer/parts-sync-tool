# == Schema Information
#
# Table name: order_sku_links
#
#  id         :bigint           not null, primary key
#  order_id   :bigint           not null
#  sku_id     :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class OrderSkuLinkTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
