class SalesReportController < ApplicationController
  def index
    @report_data = Order.report_data
  end
end
