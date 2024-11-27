class CreateSalesChannelFees < ActiveRecord::Migration[7.2]
  def change
    create_table :sales_channel_fees do |t|
      t.references :sales_channel, null: false, foreign_key: true
      t.decimal :fee_rate

      t.timestamps
    end
  end
end
