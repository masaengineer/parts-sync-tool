# == Schema Information
#
# Table name: order_lines
#
#  id             :bigint           not null, primary key
#  seller_sku_id  :bigint           not null
#  quantity       :integer
#  unit_price     :decimal(, )
#  line_item_id   :integer
#  line_item_name :string
#  order_id       :bigint           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require 'rails_helper'

RSpec.describe OrderLine, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
