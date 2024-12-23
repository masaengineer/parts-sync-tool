# == Schema Information
#
# Table name: procurements
#
#  id             :bigint           not null, primary key
#  purchase_price :decimal(, )
#  forwarding_fee :decimal(, )
#  photo_fee      :decimal(, )
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  handling_fee   :decimal(10, 2)
#  order_id       :bigint           not null
#
# Indexes
#
#  index_procurements_on_order_id  (order_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (order_id => orders.id)
#
require "test_helper"

class ProcurementTest < ActiveSupport::TestCase
  def setup
    @order = orders(:one)
    @procurement = procurements(:one)
  end

  test "should be valid with valid attributes" do
    assert @procurement.valid?
  end

  test "should require an order" do
    @procurement.order = nil
    assert_not @procurement.valid?
  end

  test "should require a purchase price" do
    @procurement.purchase_price = nil
    assert_not @procurement.valid?
  end

  test "should calculate total cost correctly" do
    @procurement.purchase_price = 100
    @procurement.forwarding_fee = 50
    @procurement.photo_fee = 30
    @procurement.handling_fee = 20

    assert_equal 200, @procurement.total_cost
  end

  test "should handle nil values in total cost calculation" do
    @procurement.purchase_price = 100
    @procurement.forwarding_fee = nil
    @procurement.photo_fee = 30
    @procurement.handling_fee = nil

    assert_equal 130, @procurement.total_cost
  end

  test "should enforce one-to-one relationship with order" do
    duplicate_procurement = @procurement.dup
    assert_not duplicate_procurement.valid?
    assert_includes duplicate_procurement.errors[:order_id], "has already been taken"
  end
end
