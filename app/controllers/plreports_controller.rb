class PlreportsController < ApplicationController
  def index
    year = params[:year].presence || Date.today.year

    # 指定年の注文を取得
    orders = Order.where("extract(year from sale_date) = ?", year)
                  .includes(
                    :sale,
                    :shipment,
                    :payment_fees,
                    order_sku_links: { sku: [:procurements] }
                  )

    # 月別に集計するための初期化（1～12月分のハッシュを用意）
    @monthly_data = (1..12).map do |month|
      {
        month: month,
        revenue: 0,
        procurement_cost: 0,
        shipping_cost: 0,
        payment_fees: 0,
        expenses: 0
      }
    end

    # 各OrderをReportCalculatorで計算して月別に集計
    orders.each do |order|
      next unless order.sale_date.present?

      # 売上日が何月か
      month = order.sale_date.month
      data = @monthly_data[month - 1]

      # サービスクラスで計算
      calc_result = ReportCalculator.new(order).calculate
      # calc_resultの中身:
      # {
      #   order: order,
      #   revenue: ... (USD),
      #   payment_fees: ... (USD),
      #   shipping_cost: ... (円),
      #   procurement_cost: ... (円),
      #   quantity: ...,
      #   profit: ... (円),
      #   profit_rate: ... (％)
      # }

      # ここで月別合計に足し込む。
      # ただしPLレポートでは「売上高(revenue)」「原価(procurement_cost)」「送料(shipping_cost)」「手数料(payment_fees)」は円換算後を使う方が一貫する場合も。
      # しかし、本例では売上と手数料を「ドル→円換算した値」を足し込むならcalc_result[:profit]やcalc_result[:profit_rate]だけではなく、内訳の円換算値を取り出す必要がある。
      # ここではサンプルとして calc_result[:profit] や calc_result[:profit_rate] ではなく、calc_result[:procurement_cost], calc_result[:shipping_cost]などを足す例にする。

      # 売上(revenue)はcalc_result[:revenue](USD)に対して 140倍した値を加算
      revenue_jpy = calc_result[:revenue] * ReportCalculator::USD_TO_JPY
      data[:revenue] += revenue_jpy

      # 手数料も同様にドルを円換算
      payment_fees_jpy = calc_result[:payment_fees] * ReportCalculator::USD_TO_JPY
      data[:payment_fees] += payment_fees_jpy

      # 送料(円)
      data[:shipping_cost] += calc_result[:shipping_cost]

      # 原価(円)
      data[:procurement_cost] += calc_result[:procurement_cost]
    end

    # 販管費(Expensesテーブル)を年・月別に集計
    expenses_by_month = Expense.where(year: year).group(:month).sum(:amount)
    @monthly_data.each do |data|
      m = data[:month]
      data[:expenses] = expenses_by_month[m].to_f if expenses_by_month.key?(m)
    end

    # 月別計算
    @monthly_data.each do |data|
      revenue = data[:revenue]
      procurement_cost = data[:procurement_cost]
      payment_fees = data[:payment_fees]
      shipping_cost = data[:shipping_cost]
      expenses = data[:expenses]

      # 粗利 = 売上 - 原価
      gross_profit = revenue - procurement_cost

      # 限界利益 = 売上高 - (原価 + 送料 + 手数料)
      contribution_margin = revenue - (procurement_cost + shipping_cost + payment_fees)

      # 限界利益率 = 限界利益 / 売上高 * 100
      contribution_margin_rate = revenue.zero? ? 0 : (contribution_margin / revenue * 100)

      data[:gross_profit] = gross_profit
      data[:contribution_margin] = contribution_margin
      data[:contribution_margin_rate] = contribution_margin_rate
    end
  end
end
