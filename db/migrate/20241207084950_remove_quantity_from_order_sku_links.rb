class RemoveQuantityFromOrderSkuLinks < ActiveRecord::Migration[7.2]
  def change
    remove_column :order_sku_links, :quantity, :integer
  end
end
