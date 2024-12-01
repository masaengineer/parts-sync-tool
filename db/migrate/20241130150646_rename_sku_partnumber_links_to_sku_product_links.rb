class RenameSkuPartnumberLinksToSkuProductLinks < ActiveRecord::Migration[7.0]
  def change
    rename_table :sku_part_number_links, :sku_product_links
  end
end
