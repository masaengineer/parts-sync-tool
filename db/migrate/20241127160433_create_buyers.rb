class CreateBuyers < ActiveRecord::Migration[7.2]
  def change
    create_table :buyers do |t|
      t.string :name
      t.string :email
      t.references :address, null: false, foreign_key: true

      t.timestamps
    end
  end
end
