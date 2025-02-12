# app/controllers/sales_reports_controller.rb

class SalesReportsController < ApplicationController
  def index
    @q = current_user.orders.ransack(params[:q])
    @per_page = (params[:per_page] || 30).to_i
    @orders = @q.result
                .includes(
                  :sale,
                  :shipment,
                  :payment_fees,
                  :procurement,
                  order_lines: {
                    seller_sku: :manufacturer_skus
                  }
                )
                .page(params[:page])
                .per(@per_page)

    # ReportCalculatorを用いて計算を行う
    @orders_data = @orders.map do |order|
      ReportCalculator.new(order).calculate
    end
  end

  def show
    @order = current_user.orders.includes(
      :procurement,
      order_lines: :manufacturer_skus
    ).find(params[:id])
    render partial: "order_detail_modal", locals: { order: @order }
  end
end
