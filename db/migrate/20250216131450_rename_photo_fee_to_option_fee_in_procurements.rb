class RenamePhotoFeeToOptionFeeInProcurements < ActiveRecord::Migration[7.2]
  def change
    rename_column :procurements, :photo_fee, :option_fee
  end
end
