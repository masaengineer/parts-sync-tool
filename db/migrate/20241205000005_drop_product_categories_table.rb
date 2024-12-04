class DropProductCategoriesTable < ActiveRecord::Migration[7.2]
  def up
    # 外部キー制約の確認と削除
    execute <<-SQL
      DO $$
      BEGIN
        -- 外部キー制約を削除
        IF EXISTS (
          SELECT 1
          FROM information_schema.table_constraints
          WHERE constraint_name = 'fk_rails_products_product_categories'
        ) THEN
          ALTER TABLE products
          DROP CONSTRAINT fk_rails_products_product_categories;
        END IF;

        -- product_categoriesテーブルの削除
        IF EXISTS (
          SELECT 1
          FROM information_schema.tables
          WHERE table_name = 'product_categories'
        ) THEN
          DROP TABLE IF EXISTS product_categories CASCADE;
        END IF;
      END
      $$;
    SQL

    # productsテーブルからproduct_categories_idカラムを削除
    remove_column :products, :product_categories_id if column_exists?(:products, :product_categories_id)

    # テーブルの削除
    drop_table :product_categories, force: :cascade if table_exists?(:product_categories)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
