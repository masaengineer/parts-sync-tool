class CreateManufacturerSkus < ActiveRecord::Migration[7.2]
  def change
    create_table :manufacturer_skus do |t|
      t.string :sku_code
      t.references :manufacturer, null: false, foreign_key: true

      t.timestamps
    end
    add_index :manufacturer_skus, :sku_code, unique: true
  end
end
