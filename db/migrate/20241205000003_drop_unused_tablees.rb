class DropUnusedTablees < ActiveRecord::Migration[7.2]
  def up
    # 外部キー制約の確認と削除
    execute <<-SQL
      DO $$
      BEGIN
        -- 各テーブルの外部キー制約を削除
        IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'advertising_costs') THEN
          DROP TABLE IF EXISTS advertising_costs CASCADE;
        END IF;
        -- 他のテーブルも同様に
      END
      $$;
    SQL

    # テーブルの削除（force: :cascade オプションを追加）
    drop_table :advertising_costs, force: :cascade if table_exists?(:advertising_costs)
    drop_table :inventories, force: :cascade if table_exists?(:inventories)
    drop_table :quotation_items, force: :cascade if table_exists?(:quotation_items)
    drop_table :quotation_item_changes, force: :cascade if table_exists?(:quotation_item_changes)
    drop_table :quotations, force: :cascade if table_exists?(:quotations)
    drop_table :wholesalers, force: :cascade if table_exists?(:wholesalers)
    drop_table :sales_channel_fees, force: :cascade if table_exists?(:sales_channel_fees)
    drop_table :sales_channels, force: :cascade if table_exists?(:sales_channels)
    drop_table :contact_informations, force: :cascade if table_exists?(:contact_informations)
    drop_table :addresses, force: :cascade if table_exists?(:addresses)
    drop_table :remarks, force: :cascade if table_exists?(:remarks)
    drop_table :order_status_histories, force: :cascade if table_exists?(:order_status_histories)
    drop_table :buyers, force: :cascade if table_exists?(:buyers)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
