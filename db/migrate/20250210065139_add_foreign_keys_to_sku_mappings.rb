class AddForeignKeysToSkuMappings < ActiveRecord::Migration[7.2]
  def change
    add_reference :sku_mappings, :seller_sku, null: false, foreign_key: true
    add_reference :sku_mappings, :manufacturer_sku, null: false, foreign_key: true
  end
end
