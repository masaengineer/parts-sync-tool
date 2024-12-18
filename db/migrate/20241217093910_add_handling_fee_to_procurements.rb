class AddHandlingFeeToProcurements < ActiveRecord::Migration[7.0]
  def change
    add_column :procurements, :handling_fee, :decimal, precision: 10, scale: 2
  end
end
