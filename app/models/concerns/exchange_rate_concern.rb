module ExchangeRateConcern
  extend ActiveSupport::Concern

  # 為替レートの定数
  # 環境変数から取得するか、デフォルト値を使用
  USD_TO_JPY_RATE = ENV.fetch("USD_TO_JPY_RATE", 150.0).to_f

  # USD → JPYの変換メソッド
  def convert_usd_to_jpy(usd_amount)
    return 0 if usd_amount.nil?
    (usd_amount.abs * USD_TO_JPY_RATE).round(0)
  end
end
