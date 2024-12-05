class ChangeProductIdToSkuIdInProcurements < ActiveRecord::Migration[7.0]
  def change
    # product_id カラムの削除
    remove_reference :procurements, :product, foreign_key: true
    
    # sku_id カラムの追加
    add_reference :procurements, :sku, foreign_key: true
  end
end
