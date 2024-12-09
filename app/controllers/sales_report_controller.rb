class SalesReportController < ApplicationController
  def index
    @orders = Order.page(params[:page]).per(10)  # 1ページあたり10件表示
  end
end
