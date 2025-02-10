module Ebay
  class OrderDataImportService
    def initialize(orders_data)
      @orders_data = orders_data
      Rails.logger.debug "Ebay::OrderDataImportService initialized" # 初期化ログ
    end

    def import(current_user)
      Rails.logger.debug "import called with user: #{current_user.id}" # メソッド呼び出しログ
      ApplicationRecord.transaction do
        @orders_data['orders'].each do |ebay_order|
          import_order(ebay_order, current_user)
        end
      end
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error "データ保存エラー: #{e.message}"
      raise ::Ebay::FulfillmentService::FulfillmentError, "データ保存中にエラーが発生しました: #{e.message}"
    rescue StandardError => e
      Rails.logger.error "予期せぬエラー: #{e.message}"
      raise ::Ebay::FulfillmentService::FulfillmentError, "予期せぬエラーが発生しました: #{e.message}"
    end

    private

    def import_order(order_data, current_user)
      Rails.logger.debug "import_order called with order_data: #{order_data['orderId']}, user: #{current_user.id}" # メソッド呼び出しログ
      return if current_user.blank?

      order = Order.find_or_initialize_by(order_number: order_data['orderId'], user_id: current_user.id)
      order.update!(
        sale_date:  order_data['creationDate'],
        user_id:    current_user.id
      )
      Rails.logger.debug "Order updated: #{order.inspect}" # Order更新ログ

      import_order_lines(order, order_data['lineItems'])
      import_sale(order, order_data)
      import_shipment(order, order_data)
    end

    def import_order_lines(order, line_items)
      Rails.logger.debug "import_order_lines called for order: #{order.id}"
      line_items.each do |line_item|
        Rails.logger.debug "Processing line_item: #{line_item.inspect}" # デバッグログを追加

        # nil チェックを追加
        unless line_item
          Rails.logger.error "Line item is nil"
          next
        end

        seller_sku = ::SellerSku.find_or_create_by!(sku_code: line_item['sku'])
        Rails.logger.debug "SellerSku found or created: #{seller_sku.inspect}"

        # 必要なデータの存在確認
        unless line_item['quantity'] && line_item['unitPrice'] && line_item['unitPrice']['value']
          Rails.logger.error "Required line item data is missing: #{line_item.inspect}"
          next
        end

        order_line = OrderLine.find_or_initialize_by(
          order_id: order.id,
          line_item_id: line_item['lineItemId']
        )

        order_line.update!(
          seller_sku_id:  seller_sku.id,
          quantity:       line_item['quantity'],
          unit_price:     line_item['unitPrice']['value'],
          line_item_name: line_item['title'],
          line_item_id:   line_item['lineItemId']
        )
        Rails.logger.debug "OrderLine updated: #{order_line.inspect}"
      end
    end

    def import_sale(order, order_data)
      Rails.logger.debug "import_sale called for order: #{order.id}" # メソッド呼び出しログ
      sale = Sale.find_or_initialize_by(order_id: order.id)
      sale.update!(
        order_net_amount:   order_data.dig('pricingSummary', 'total', 'value'),
        order_gross_amount: order_data.dig('paymentSummary', 'totalDueSeller', 'value')
      )
      Rails.logger.debug "Sale updated: #{sale.inspect}" # Sale更新ログ
    end

    def import_shipment(order, order_data)
      Rails.logger.debug "import_shipment called for order: #{order.id}" # メソッド呼び出しログ
      # 複数の配送情報がある場合、最初のものだけを保存
      first_fulfillment_href = order_data.dig('lineItems', 0, 'fulfilmentHrefs', 0)
      return unless first_fulfillment_href.present?

      # fulfillmentHrefsからtracking_numberを抽出
      tracking_number = first_fulfillment_href.split('/').last

      shipment = Shipment.find_or_initialize_by(order_id: order.id)
      shipment.update!(
        tracking_number: tracking_number
      )
      Rails.logger.debug "Shipment updated: #{shipment.inspect}" # Shipment更新ログ
    end
  end
end
