module Ebay
  class PromotedListingFeeImporter
    class ImportError < StandardError; end

    def initialize(api_client = FinanceApiClient.new)
      @api_client = api_client
    end

    def import
      transactions = @api_client.fetch_transactions
      process_transactions(transactions)
    rescue StandardError => e
      Rails.logger.error "PromotedListingFee import error: #{e.message}"
      raise ImportError, "広告費用のインポートに失敗しました: #{e.message}"
    end

    private

    def process_transactions(transactions)
      ad_fee_transactions = transactions.select do |transaction|
        transaction["transactionType"] == "NON_SALE_CHARGE" &&
        transaction["feeType"] == "AD_FEE"
      end

      ad_fee_transactions.each do |transaction|
        order_reference = transaction["references"]&.find { |ref| ref["referenceType"] == "ORDER_ID" }
        next unless order_reference

        order = Order.find_by(order_number: order_reference["referenceId"])
        next unless order

        create_payment_fee(order, transaction)
      end
    end

    def create_payment_fee(order, transaction)
      fee_amount = transaction.dig("amount", "value")
      return unless fee_amount

      PaymentFee.create!(
        order: order,
        fee_category: :promoted_listing_fee_standard, # enumで定義
        fee_amount: fee_amount.to_d
      )
    end
  end
end
