class RemoveCurrencyIdFromSales < ActiveRecord::Migration[7.0]
  def change
    remove_column :sales, :currency_id, :integer
  end
end 
