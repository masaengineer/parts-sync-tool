class CreateAddresses < ActiveRecord::Migration[7.2]
  def change
    create_table :addresses do |t|
      t.string :address_primary
      t.string :address_secondary
      t.string :city
      t.string :state_province
      t.string :postal_code
      t.string :country
      t.string :address_formats

      t.timestamps
    end
  end
end
