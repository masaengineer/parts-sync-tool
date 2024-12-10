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
require "test_helper"

class ProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
