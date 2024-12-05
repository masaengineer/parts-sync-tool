class AdjustProductsTableStructure < ActiveRecord::Migration[7.2]
  def up
    change_table :products do |t|
      # 不要なカラムを削除
      t.remove :is_oem if column_exists?(:products, :is_oem)
      t.remove :domestic_title if column_exists?(:products, :domestic_title)
      t.remove :product_status if column_exists?(:products, :product_status)
    end

    # インデックスの再設定（必要に応じて）
    unless index_exists?(:products, :oem_part_number)
      add_index :products, :oem_part_number
    end
  end

  def down
    change_table :products do |t|
      # ロールバック時のカラム復元
      t.boolean :is_oem unless column_exists?(:products, :is_oem)
      t.string :domestic_title unless column_exists?(:products, :domestic_title)
      t.string :product_status unless column_exists?(:products, :product_status)
    end
  end
end
