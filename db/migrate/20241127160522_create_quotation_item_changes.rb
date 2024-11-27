class CreateQuotationItemChanges < ActiveRecord::Migration[7.2]
  def change
    create_table :quotation_item_changes do |t|
      t.references :quotation_item, null: false, foreign_key: true
      t.string :original_part_number
      t.string :new_part_number
      t.datetime :change_date
      t.string :change_reason

      t.timestamps
    end
  end
end
