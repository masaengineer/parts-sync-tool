class AddTransactionTypeToPaymentFees < ActiveRecord::Migration[7.2]
  def change
    add_column :payment_fees, :transaction_type, :string
  end
end
