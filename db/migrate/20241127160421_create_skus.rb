class CreateSkus < ActiveRecord::Migration[7.2]
  def change
    create_table :skus do |t|
      t.string :sku_code

      t.timestamps
    end
  end
end
