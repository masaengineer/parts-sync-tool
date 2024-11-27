class CreateAdvertisingCosts < ActiveRecord::Migration[7.2]
  def change
    create_table :advertising_costs do |t|
      t.references :order, null: false, foreign_key: true
      t.decimal :product_ad_cost

      t.timestamps
    end
  end
end
