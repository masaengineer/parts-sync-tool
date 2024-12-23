# app/controllers/sales_reports_controller.rb

class SalesReportsController < ApplicationController
  def index
    @q = Order.ransack(params[:q])
    @orders = @q.result
                .includes(
                  :sale,
                  :shipment,
                  :payment_fees,
                  :procurement,
                  order_sku_links: {
                    sku: :manufacturer
                  }
                )
                .page(params[:page])
                .per(30)

    # ReportCalculatorを用いて計算を行う
    @orders_data = @orders.map do |order|
      ReportCalculator.new(order).calculate
    end
  end

  def show
    @order = Order.includes(
      :procurement,
      order_sku_links: {
        sku: :manufacturer
      }
    ).find(params[:id])
    render partial: "order_detail_modal", locals: { order: @order }
  end
end
