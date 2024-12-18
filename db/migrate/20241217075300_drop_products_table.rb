class DropProductsTable < ActiveRecord::Migration[7.0]
  def up
    drop_table :products
  end

  def down
    create_table :products do |t|
      # 元のテーブル構造を記述
      # 必要なカラムを定義
      t.timestamps
    end
  end
end
