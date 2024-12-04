class DropCurrenciesTable < ActiveRecord::Migration[7.2]
  def up
    # 外部キー制約の確認と削除
    execute <<-SQL
      DO $$
      BEGIN
        -- currenciesテーブルの外部キー制約を削除
        IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'currencies') THEN
          DROP TABLE IF EXISTS currencies CASCADE;
        END IF;
      END
      $$;
    SQL

    # テーブルの削除
    drop_table :currencies, force: :cascade if table_exists?(:currencies)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
