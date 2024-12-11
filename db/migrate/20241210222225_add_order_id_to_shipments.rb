class AddOrderIdToShipments < ActiveRecord::Migration[7.2]
  def change
    add_column :shipments, :order_id, :bigint
    add_index :shipments, :order_id
  end
end
