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
# Indexes
#
#  index_sku_product_links_on_product_id             (product_id)
#  index_sku_product_links_on_sku_id                 (sku_id)
#  index_sku_product_links_on_sku_id_and_product_id  (sku_id,product_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#  fk_rails_...  (sku_id => skus.id)
#
require "test_helper"

class SkuProductLinkTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
