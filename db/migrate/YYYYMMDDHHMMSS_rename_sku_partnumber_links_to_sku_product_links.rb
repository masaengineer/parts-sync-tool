class RenameSkuPartnumberLinksToSkuProductLinks < ActiveRecord::Migration[7.0]
  def change
    rename_table :sku_partnumber_links, :sku_product_links
  end
end
