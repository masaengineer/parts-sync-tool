class RemoveLineItemIdFromSellerSkus < ActiveRecord::Migration[7.2]
  def change
    remove_column :seller_skus, :line_item_id, :string
  end
end
