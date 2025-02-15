class AddTransactionIdToPaymentFees < ActiveRecord::Migration[7.2]
  def change
    add_column :payment_fees, :transaction_id, :string
    add_index :payment_fees, :transaction_id, unique: true
  end
end
