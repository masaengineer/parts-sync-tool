class DropUnusedTables < ActiveRecord::Migration[7.2]
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

    # テーブルの削除
    drop_table :advertising_costs if table_exists?(:advertising_costs)
    drop_table :inventories if table_exists?(:inventories)
    drop_table :quotation_items if table_exists?(:quotation_items)
    drop_table :quotation_item_change
  end
end
