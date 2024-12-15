module ApplicationHelper
  def full_title(page_title = '')
    base_title = "Parts Sync"
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end

  EXCHANGE_RATE = 150 # 仮のレート。実際は定数ファイル、環境変数、Rails.credentialsなどで管理を検討

  def usd_to_jpy(amount_in_usd)
    (amount_in_usd * EXCHANGE_RATE).round
  end

  def number_to_yen(amount_in_usd)
    number_to_currency(usd_to_jpy(amount_in_usd), unit: "¥", format: "%u%n", precision: 0)
  end
end
