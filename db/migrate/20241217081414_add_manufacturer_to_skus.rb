class AddManufacturerToSkus < ActiveRecord::Migration[7.2]
  def change
    add_reference :skus, :manufacturer, null: false, foreign_key: true
  end
end
