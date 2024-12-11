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
# Indexes
#
#  index_order_sku_links_on_order_id             (order_id)
#  index_order_sku_links_on_order_id_and_sku_id  (order_id,sku_id) UNIQUE
#  index_order_sku_links_on_sku_id               (sku_id)
#
# Foreign Keys
#
#  fk_rails_...  (order_id => orders.id)
#  fk_rails_...  (sku_id => skus.id)
#
require "test_helper"

class OrderSkuLinkTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
