class CreateProcurements < ActiveRecord::Migration[7.2]
  def change
    create_table :procurements do |t|
      t.references :order, null: false, foreign_key: true
      t.decimal :purchase_price
      t.decimal :domestic_transfer_fee
      t.decimal :forwarding_fee
      t.decimal :photo_fee

      t.timestamps
    end
  end
end
