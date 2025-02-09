module Ebay
  class FulfillmentService
    class FulfillmentError < StandardError; end

    API_ENDPOINT = '/sell/fulfillment/v1/order'.freeze

    def initialize
      @auth_service = AuthService.new
      validate_auth_token
    end

    def fetch_orders(params = {})
      response = client.get do |req|
        url = API_ENDPOINT
        req.url url
        req.headers = auth_headers
        req.params = default_params.merge(params)

        # デバッグ用にリクエストの詳細をログ出力
        Rails.logger.debug "Request URL: #{url}"
        Rails.logger.debug "Request Headers: #{req.headers}"
        Rails.logger.debug "Request Params: #{req.params}"
      end

      JSON.parse(response.body)
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
      raise FulfillmentError, 'アクセストークンの取得に失敗しました' if token.nil?
      token
    end

    def client
      @client ||= Faraday.new(url: 'https://api.ebay.com') do |faraday|
        faraday.request :json
        faraday.response :raise_error
        faraday.adapter Faraday.default_adapter
        # デバッグログを有効化
        faraday.response :logger, Rails.logger, bodies: true
      end
    end

    def auth_headers
      {
        'Authorization' => "Bearer #{validate_auth_token}",
        'Content-Type' => 'application/json',
        'Accept' => 'application/json',
      }
    end

    def default_params
      {
        limit: 50,
        offset: 0
      }
    end
  end
end
