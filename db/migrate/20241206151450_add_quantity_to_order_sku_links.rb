class AddQuantityToOrderSkuLinks < ActiveRecord::Migration[7.0]
  def change
    add_column :order_sku_links, :quantity, :integer
  end
end
