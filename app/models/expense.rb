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
class Expense < ApplicationRecord
  # 独立したテーブルのため、アソシエーションなし
end
