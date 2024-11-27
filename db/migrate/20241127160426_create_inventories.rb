class CreateInventories < ActiveRecord::Migration[7.2]
  def change
    create_table :inventories do |t|
      t.references :product, null: false, foreign_key: true
      t.integer :quantity
      t.date :stock_order_date
      t.string :stock_type

      t.timestamps
    end
  end
end
