class CreateProcurementWithOrderAssociation < ActiveRecord::Migration[7.0]
  def up
    # 既存の外部キー制約を削除
    remove_foreign_key :procurements, :skus if foreign_key_exists?(:procurements, :skus)

    # sku_idカラムを削除
    remove_column :procurements, :sku_id if column_exists?(:procurements, :sku_id)

    # order_idカラムを追加
    add_reference :procurements, :order, null: false, foreign_key: true, index: { unique: true }
  end

  def down
    # order_idカラムを削除
    remove_reference :procurements, :order

    # sku_idカラムを追加し直す
    add_reference :procurements, :sku, null: true
    add_foreign_key :procurements, :skus
  end
end
