class CreateProductCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :product_categories do |t|
      t.string :category_name
      t.text :description
      t.integer :parent_category_id

      t.timestamps
    end
  end
end
