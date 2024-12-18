# db/migrate/[timestamp]_move_international_title_from_products_to_skus.rb

class MoveInternationalTitleFromProductsToSkus < ActiveRecord::Migration[7.2]
  def change
    # SKUsテーブルにinternational_titleカラムを追加
    add_column :skus, :international_title, :string

    # Productsテーブルからinternational_titleカラムを削除
    remove_column :products, :international_title, :string
  end
end
