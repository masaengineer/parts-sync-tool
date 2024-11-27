class CreateShipments < ActiveRecord::Migration[7.2]
  def change
    create_table :shipments do |t|
      t.references :order, null: false, foreign_key: true
      t.string :carrier
      t.string :shipping_method
      t.float :weight
      t.float :length
      t.float :width
      t.float :height
      t.string :destination_country
      t.string :tracking_number
      t.float :customer_domestic_shipping
      t.float :customer_international_shipping

      t.timestamps
    end
  end
end
