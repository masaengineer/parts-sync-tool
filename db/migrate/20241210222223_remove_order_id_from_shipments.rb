class RemoveOrderIdFromShipments < ActiveRecord::Migration[7.2]
  def change
    remove_column :shipments, :order_id, :bigint
  end
end
