class AdjustUsersTableForDevise < ActiveRecord::Migration[7.2]
  def up
    change_table :users do |t|
      # 不要なカラムを削除
      t.remove :password_digest if column_exists?(:users, :password_digest)
      t.remove :role if column_exists?(:users, :role)

      # deviseの標準カラムを追加（まだ存在しない場合）
      unless column_exists?(:users, :encrypted_password)
        t.string :encrypted_password, null: false, default: ""
      end

      unless column_exists?(:users, :reset_password_token)
        t.string   :reset_password_token
        t.datetime :reset_password_sent_at
        t.datetime :remember_created_at
      end

      # 既存のインデックスを確認して追加
      unless index_exists?(:users, :email)
        t.index :email, unique: true
      end
      unless index_exists?(:users, :reset_password_token)
        t.index :reset_password_token, unique: true
      end
    end

    # null: false 制約を追加
    change_column_null :users, :email, false
  end

  def down
    change_table :users do |t|
      t.string :password_digest unless column_exists?(:users, :password_digest)

      # deviseの標準カラムを削除
      t.remove :encrypted_password if column_exists?(:users, :encrypted_password)
      t.remove :reset_password_token if column_exists?(:users, :reset_password_token)
      t.remove :reset_password_sent_at if column_exists?(:users, :reset_password_sent_at)
      t.remove :remember_created_at if column_exists?(:users, :remember_created_at)
    end

    remove_index :users, :email if index_exists?(:users, :email)
    remove_index :users, :reset_passiword_token if index_exists?(:users, :reset_password_token)
  end
end
