class CreateRemarks < ActiveRecord::Migration[7.2]
  def change
    create_table :remarks do |t|
      t.references :order, null: false, foreign_key: true
      t.text :partner_note
      t.text :internal_note

      t.timestamps
    end
  end
end
