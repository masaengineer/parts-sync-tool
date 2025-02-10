class EbayOrdersController < ApplicationController
  def index
    begin
      @fulfillment_service = Ebay::FulfillmentService.new
      @orders = @fulfillment_service.fetch_orders(current_user)
    rescue Ebay::FulfillmentService::FulfillmentError => e
      flash.now[:alert] = e.message
      @orders = [] # エラー時は空の配列をセット
    end
  end

  def import_orders
    begin
      fulfillment_service = Ebay::FulfillmentService.new
      orders = fulfillment_service.fetch_orders(current_user)
      # importメソッドの引数を修正
      Ebay::OrderDataImportService.new(orders).import(current_user)
      redirect_to ebay_orders_path, notice: t('ebay_orders.import_success')
    rescue Ebay::FulfillmentService::FulfillmentError => e
      redirect_to ebay_orders_path, alert: e.message
    end
  end
end
