class PlreportsController < ApplicationController
  def index
    year = params[:year].presence || Date.today.year
    # 該当年の注文を取得
    orders = Order.where("extract(year from sale_date) = ?", year)
      .includes(
        :sale,
        :shipment,
        :payment_fees,
        order_sku_links: { sku: [:procurements] }
      )

    # 月別に集計するための初期化（1～12月分のハッシュを用意）
    @monthly_data = (1..12).map do |month|
      { month: month, revenue: 0, procurement_cost: 0, shipping_cost: 0, payment_fees: 0, expenses: 0 }
    end

    # 月ごとにOrderを集計
    orders.each do |order|
      next unless order.sale_date.present?
      month = order.sale_date.month
      data = @monthly_data[month - 1]

      # 売上高
      revenue = order.sale&.order_net_amount.to_f
      # 支払手数料合計
      payment_fees = order.payment_fees.sum(&:fee_amount).to_f
      # 送料
      shipping_cost = order.shipment&.customer_international_shipping.to_f

      # 原価計算（SKU経由でProcurementを参照する）
      procurement_cost = order.order_sku_links.sum do |osl|
        # 原価要素はモデルによって変わるがここではpurchase_price + forwarding_fee + photo_feeと仮定
        osl.sku.procurements.sum { |p| p.purchase_price.to_f + p.forwarding_fee.to_f + p.photo_fee.to_f }
      end

      # 集計を足し込む
      data[:revenue]           += revenue
      data[:payment_fees]      += payment_fees
      data[:shipping_cost]     += shipping_cost
      data[:procurement_cost]  += procurement_cost
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
