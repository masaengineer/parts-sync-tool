class RemoveTrackingNumberFromShipments < ActiveRecord::Migration[7.0]
  def change
    remove_column :shipments, :tracking_number, :string
  end
end
