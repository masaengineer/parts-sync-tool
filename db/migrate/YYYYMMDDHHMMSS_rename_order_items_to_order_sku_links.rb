class RenameOrderItemsToOrderSkuLinks < ActiveRecord::Migration[7.0]
  def change
    rename_table :order_items, :order_sku_links
  end
end
