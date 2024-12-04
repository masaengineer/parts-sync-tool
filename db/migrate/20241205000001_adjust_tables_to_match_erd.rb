class AdjustTablesToMatchErd < ActiveRecord::Migration[7.2]
  def change
    # 不要なテーブルの削除
    drop_table :advertising_costs, force: :cascade
    drop_table :inventories, force: :cascade
    drop_table :quotation_items, force: :cascade
    drop_table :quotation_item_changes, force: :cascade
    drop_table :quotations, force: :cascade
    drop_table :wholesalers, force: :cascade
    drop_table :sales_channel_fees, force: :cascade
    drop_table :sales_channels, force: :cascade
    drop_table :contact_informations, force: :cascade
    drop_table :addresses, force: :cascade
    drop_table :remarks, force: :cascade
    drop_table :order_status_histories, force: :cascade

    # Salesテーブルの修正
    change_table :sales do |t|
      t.rename :price_original, :net_amount
      t.decimal :gross_amount
      t.remove :currency_code
    end

    # PaymentFeesテーブルの修正
    change_table :payment_fees do |t|
      t.remove :fee_type
      t.decimal :fee_amount
      t.remove :sales_channel_id
      t.remove :currency_id
      t.remove :fee_confirmed_at
      t.remove :note
    end

    # Procurementsテーブルの修正
    change_table :procurements do |t|
      t.remove :domestic_transfer_fee
    end

    # Shipmentsテーブルの修正
    change_table :shipments do |t|
      t.integer :cpass_trade_id
      t.remove :carrier
      t.remove :shipping_method
      t.remove :weight
      t.remove :length
      t.remove :width
      t.remove :height
      t.remove :destination_country
      t.remove :customer_domestic_shipping
      t.change :customer_international_shipping, :decimal
    end
  end
end
