class RenameSalesAmountColumns < ActiveRecord::Migration[7.0]
  def change
    # net_amountをorder_net_amountに変更
    rename_column :sales, :net_amount, :order_net_amount

    # gross_amountをorder_gross_amountに変更
    rename_column :sales, :gross_amount, :order_gross_amount
  end
end
