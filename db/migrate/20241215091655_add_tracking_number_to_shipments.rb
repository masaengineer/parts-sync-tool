class AddTrackingNumberToShipments < ActiveRecord::Migration[7.2]
  def change
    add_column :shipments, :tracking_number, :string
  end
end
