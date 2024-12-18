class DropSkuProductLinksTable < ActiveRecord::Migration[7.2]
  def up
    # 外部キー制約がある場合は先に削除
    remove_foreign_key :sku_product_links, :skus if foreign_key_exists?(:sku_product_links, :skus)
    drop_table :sku_product_links
  end

  def down
    create_table :sku_product_links do |t|
      t.references :sku, null: false, foreign_key: true
      t.timestamps
    end
  end
end
