class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string :oem_part_number
      t.boolean :is_oem
      t.string :domestic_title
      t.string :international_title
      t.string :product_status
      t.references :product_categories, null: false, foreign_key: true

      t.timestamps
    end
  end
end
