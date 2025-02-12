module Ebay
  class FulfillmentService
    class FulfillmentError < StandardError; end

    API_ENDPOINT = '/sell/fulfillment/v1/order'.freeze

    def initialize
      @auth_service = AuthService.new
      Rails.logger.debug "Ebay::FulfillmentService initialized" # 初期化ログ
      validate_auth_token
    end

    def fetch_orders(current_user)
      Rails.logger.debug "fetch_orders called with user: #{current_user.id}"
      all_orders = []
      offset = 0
      limit = 200  # 最大値を使用

      loop do
        response = client.get do |req|
          req.url API_ENDPOINT
          req.headers = auth_headers
          req.params = default_params.merge(
            offset: offset,
            limit: limit
          )

          # デバッグ用にリクエストの詳細をログ出力
          Rails.logger.debug "Request URL: #{API_ENDPOINT}"
          Rails.logger.debug "Request Headers: #{req.headers}"
          Rails.logger.debug "Request Params: #{req.params}"
        end

        result = JSON.parse(response.body)
        Rails.logger.debug "fetch_orders response: #{result.inspect}"

        orders = result["orders"]
        break if orders.empty?

        all_orders.concat(orders)
        offset += limit

        # nextリンクがなければ終了
        break unless result["next"]
      end

      # データ保存処理の呼び出し
      Ebay::OrderDataImportService.new({ "orders" => all_orders }).import(current_user)

      { "orders" => all_orders }
    rescue Faraday::Error => e
      Rails.logger.error "eBay API Error: #{e.response&.body}"
      raise FulfillmentError, "受注情報取得エラー: #{e.message}"
    rescue StandardError => e
      Rails.logger.error "Unexpected Error: #{e.message}"
      raise FulfillmentError, "予期せぬエラーが発生しました: #{e.message}"
    end

    private

    def validate_auth_token
      token = @auth_service.access_token
      Rails.logger.debug "validate_auth_token called. token: #{token.present? ? 'present' : 'nil'}" # トークン検証ログ
      raise FulfillmentError, 'アクセストークンの取得に失敗しました' if token.nil?
      token
    end

    def client
      Rails.logger.debug "client called" # クライアント呼び出しログ
      @client ||= Faraday.new(url: 'https://api.ebay.com') do |faraday|
        faraday.request :json
        faraday.response :raise_error
        faraday.adapter Faraday.default_adapter
        # デバッグログを有効化
        faraday.response :logger, Rails.logger, bodies: true
      end
    end

    def auth_headers
      headers = {
        'Authorization' => "Bearer #{validate_auth_token}",
        'Content-Type' => 'application/json',
        'Accept' => 'application/json',
      }
      Rails.logger.debug "auth_headers: #{headers.inspect}" # ヘッダーログ
      headers
    end

    def default_params
      params = {
        filter: "creationdate:[#{90.days.ago.utc.iso8601}..]"
      }
      Rails.logger.debug "default_params: #{params.inspect}" # パラメータログ
      params
    end
  end
end
