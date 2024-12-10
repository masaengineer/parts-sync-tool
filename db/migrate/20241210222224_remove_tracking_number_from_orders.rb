class RemoveTrackingNumberFromOrders < ActiveRecord::Migration[7.2]
  def change
    remove_column :orders, :tracking_number, :string
  end
end
