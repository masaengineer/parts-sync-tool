class SplitNameInUsers < ActiveRecord::Migration[7.0]
  def change
    # nameカラムを削除
    remove_column :users, :name, :string

    # last_nameとfirst_nameカラムを追加
    add_column :users, :last_name, :string
    add_column :users, :first_name, :string
  end
end
