class CreateSellerSkusManufacturerSkusAndSkuMappings < ActiveRecord::Migration[7.2]
  def change
    create_table :seller_skus do |t|
      t.string :sku_code, null: false
      t.string :line_item_id, null: false
      t.integer :quantity, default: 0, null: false
      t.timestamps
      t.index :sku_code, unique: true
    end
  end
end
