# == Schema Information
#
# Table name: sku_product_links
#
#  id         :bigint           not null, primary key
#  sku_id     :bigint           not null
#  product_id :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class SkuProductLinkTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
