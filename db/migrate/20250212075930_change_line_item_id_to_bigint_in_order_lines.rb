class ChangeLineItemIdToBigintInOrderLines < ActiveRecord::Migration[7.2]
  def change
    change_column :order_lines, :line_item_id, :bigint
  end
end
