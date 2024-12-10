# == Schema Information
#
# Table name: products
#
#  id                  :bigint           not null, primary key
#  oem_part_number     :string
#  international_title :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  manufacturer_id     :bigint           not null
#
# Indexes
#
#  index_products_on_manufacturer_id  (manufacturer_id)
#  index_products_on_oem_part_number  (oem_part_number)
#
# Foreign Keys
#
#  fk_rails_...  (manufacturer_id => manufacturers.id)
#
require "test_helper"

class ProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
