class CreateExpenses < ActiveRecord::Migration[7.2]
  def change
    create_table :expenses do |t|
      t.integer :year
      t.integer :month
      t.string :item_name
      t.decimal :amount

      t.timestamps
    end
  end
end
