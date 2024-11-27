class CreateSales < ActiveRecord::Migration[7.2]
  def change
    create_table :sales do |t|
      t.references :order, null: false, foreign_key: true
      t.decimal :price_original
      t.string :currency_code
      t.decimal :conversion_rate
      t.decimal :price_jpy
      t.date :conversion_date

      t.timestamps
    end
  end
end
