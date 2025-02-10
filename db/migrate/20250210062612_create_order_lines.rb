class CreateOrderLines < ActiveRecord::Migration[7.2]
  def change
    create_table :order_lines do |t|
      t.references :seller_sku, null: false, foreign_key: true
      t.integer :quantity
      t.decimal :unit_price
      t.integer :line_item_id
      t.string :line_item_name
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
