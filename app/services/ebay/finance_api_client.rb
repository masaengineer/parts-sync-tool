module Ebay
  class FinanceApiClient
    API_BASE_URL = 'https://apiz.ebay.com'.freeze
    TRANSACTION_ENDPOINT = '/sell/finances/v1/transaction'.freeze

    def initialize
      @auth_service = AuthService.new
    end

    def fetch_transactions
      response = client.get do |req|
        req.url TRANSACTION_ENDPOINT
        req.headers = auth_headers
      end
      JSON.parse(response.body)['transactions']
    rescue Faraday::Error => e
      Rails.logger.error "eBay Finance API Error: #{e.response&.body}"
      raise ApiError, "eBay Finance APIからのデータ取得に失敗しました: #{e.message}"
    end

    private

    def client
      @client ||= Faraday.new(url: API_BASE_URL) do |faraday|
        faraday.request :json
        faraday.response :raise_error
        faraday.adapter Faraday.default_adapter
      end
    end

    def auth_headers
      token = @auth_service.access_token
      raise ApiError, 'アクセストークンの取得に失敗しました' if token.nil?

      {
        'Authorization' => "Bearer #{token}",
        'Content-Type' => 'application/json'
      }
    end
  end
end
