class CreateQuotations < ActiveRecord::Migration[7.2]
  def change
    create_table :quotations do |t|
      t.references :wholesaler, null: false, foreign_key: true
      t.date :quotation_date
      t.string :status
      t.date :estimated_delivery
      t.text :wholesaler_remarks
      t.text :notes

      t.timestamps
    end
  end
end
