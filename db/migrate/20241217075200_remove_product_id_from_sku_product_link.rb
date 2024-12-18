class RemoveProductIdFromSkuProductLink < ActiveRecord::Migration[7.0]
  def up
    # 外部キー制約がある場合は先に削除
    remove_foreign_key :sku_product_links, :products if foreign_key_exists?(:sku_product_links, :products)
    remove_column :sku_product_links, :product_id
  end

  def down
    add_column :sku_product_links, :product_id, :bigint
    # 外部キー制約を戻す場合
    add_foreign_key :sku_product_links, :products
  end
end
