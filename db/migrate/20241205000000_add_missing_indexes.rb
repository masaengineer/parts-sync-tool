class AddMissingIndexes < ActiveRecord::Migration[7.2]
  def change
    # 必要なインデックスの追加
    add_index :orders, :order_number
    add_index :skus, :sku_code
    add_index :products, :oem_part_number
    add_index :manufacturers, :name
  end
end
