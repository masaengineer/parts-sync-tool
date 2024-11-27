class CreateWholesalers < ActiveRecord::Migration[7.2]
  def change
    create_table :wholesalers do |t|
      t.string :name
      t.string :contact_info
      t.text :address

      t.timestamps
    end
  end
end
