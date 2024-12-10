require "test_helper"

class SalesReportControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get sales_report_index_url
    assert_response :success
  end
end
