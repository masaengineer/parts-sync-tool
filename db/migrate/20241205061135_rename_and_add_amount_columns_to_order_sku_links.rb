class RenameAndAddAmountColumnsToOrderSkuLinks < ActiveRecord::Migration[7.0]
  def change
    # 既存のpriceカラムを削除
    remove_column :order_sku_links, :price, :decimal

    # 新しい金額カラムを追加
    add_column :order_sku_links, :sku_net_amount, :decimal, precision: 10, scale: 2
    add_column :order_sku_links, :sku_gross_amount, :decimal, precision: 10, scale: 2

    # インデックスを追加（必要に応じて）
    add_index :order_sku_links, :sku_net_amount
    add_index :order_sku_links, :sku_gross_amount
  end
end
