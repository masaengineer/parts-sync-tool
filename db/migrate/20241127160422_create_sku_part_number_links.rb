class CreateSkuPartNumberLinks < ActiveRecord::Migration[7.2]
  def change
    create_table :sku_part_number_links do |t|
      t.references :sku, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
