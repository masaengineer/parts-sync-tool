class CreateQuotationItems < ActiveRecord::Migration[7.2]
  def change
    create_table :quotation_items do |t|
      t.references :quotation, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity
      t.decimal :estimated_price

      t.timestamps
    end
  end
end
