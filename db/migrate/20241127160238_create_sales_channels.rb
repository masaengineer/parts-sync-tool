class CreateSalesChannels < ActiveRecord::Migration[7.2]
  def change
    create_table :sales_channels do |t|
      t.string :channel_name
      t.string :export_domestic_flag

      t.timestamps
    end
  end
end
