class RemoveNotNullFromSkuManufacturerId < ActiveRecord::Migration[7.0]
  def up
    # 外部キー制約を一旦削除
    remove_foreign_key :skus, :manufacturers if foreign_key_exists?(:skus, :manufacturers)

    # NOT NULL制約を削除
    change_column_null :skus, :manufacturer_id, true

    # 外部キー制約を再追加（NULL許容）
    add_foreign_key :skus, :manufacturers
  end

  def down
    # 戻す場合の処理
    remove_foreign_key :skus, :manufacturers

    # NOT NULL制約を再追加
    change_column_null :skus, :manufacturer_id, false

    # 外部キー制約を再追加
    add_foreign_key :skus, :manufacturers
  end
end
