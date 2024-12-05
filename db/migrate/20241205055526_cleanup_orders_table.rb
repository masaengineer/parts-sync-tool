class CleanupOrdersTable < ActiveRecord::Migration[7.2]
  def up
    # 外部キー制約を削除
    remove_foreign_key :orders, :sales_channels if foreign_key_exists?(:orders, :sales_channels)
    remove_foreign_key :orders, :users if foreign_key_exists?(:orders, :users)
    remove_foreign_key :orders, :buyers if foreign_key_exists?(:orders, :buyers)

    # インデックスを削除
    remove_index :orders, :sales_channel_id if index_exists?(:orders, :sales_channel_id)
    remove_index :orders, :user_id if index_exists?(:orders, :user_id)
    remove_index :orders, :buyer_id if index_exists?(:orders, :buyer_id)

    # カラムを削除
    remove_columns :orders,
                  :sales_channel_id,
                  :user_id,
                  :buyer_id,
                  :order_status
  end

  def down
    add_column :orders, :sales_channel_id, :bigint, null: false
    add_column :orders, :user_id, :bigint, null: false
    add_column :orders, :buyer_id, :bigint, null: false
    add_column :orders, :order_status, :string

    add_index :orders, :sales_channel_id
    add_index :orders, :user_id
    add_index :orders, :buyer_id

    add_foreign_key :orders, :sales_channels
    add_foreign_key :orders, :users
    add_foreign_key :orders, :buyers
  end
end
