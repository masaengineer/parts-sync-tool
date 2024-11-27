class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.string :order_number
      t.date :sale_date
      t.references :sales_channel, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :buyer, null: false, foreign_key: true
      t.string :order_status

      t.timestamps
    end
  end
end
