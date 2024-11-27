class CreatePaymentFees < ActiveRecord::Migration[7.2]
  def change
    create_table :payment_fees do |t|
      t.references :order, null: false, foreign_key: true
      t.string :fee_type
      t.decimal :fee_rate
      t.integer :option

      t.timestamps
    end
  end
end
