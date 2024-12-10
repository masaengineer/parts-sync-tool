# == Schema Information
#
# Table name: expenses
#
#  id         :bigint           not null, primary key
#  year       :integer
#  month      :integer
#  item_name  :string
#  amount     :decimal(, )
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class ExpenseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
