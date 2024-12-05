class MoveColumnsFromOrderSkuLinksToSkus < ActiveRecord::Migration[7.2]
  def change
    # SKUsテーブルに新しいカラムを追加
    add_column :skus, :quantity, :integer
    add_column :skus, :sku_net_amount, :decimal, precision: 10, scale: 2
    add_column :skus, :sku_gross_amount, :decimal, precision: 10, scale: 2

    # インデックスの追加
    add_index :skus, :sku_net_amount
    add_index :skus, :sku_gross_amount

    # order_sku_linksから既存のカラムを削除
    remove_column :order_sku_links, :quantity
    remove_column :order_sku_links, :sku_net_amount
    remove_column :order_sku_links, :sku_gross_amount
  end
end
