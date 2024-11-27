class CreateOrderStatusHistories < ActiveRecord::Migration[7.2]
  def change
    create_table :order_status_histories do |t|
      t.references :order, null: false, foreign_key: true
      t.string :order_status
      t.datetime :status_change_date
      t.string :changed_by

      t.timestamps
    end
  end
end
