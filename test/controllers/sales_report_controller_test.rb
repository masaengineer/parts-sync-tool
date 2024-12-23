require "test_helper"

class SalesReportControllerTest < ActionDispatch::IntegrationTest
  setup do
    @order = orders(:one)  # テストデータの準備が必要です
  end

  test "should get index" do
    get sales_reports_path
    assert_response :success
    assert_select "th", "仕入原価（円）"
    assert_select "th", "その他原価（円）"
  end

  test "should display procurement costs correctly" do
    get sales_reports_path
    assert_response :success

    # 仕入原価と他原価の表示を確認
    assert_select "tr.order-row" do |elements|
      elements.each do |element|
        assert_select element, "td", count: 13  # 全カラム数の確認
      end
    end
  end

  test "should calculate costs correctly" do
    calculator = ReportCalculator.new(@order)
    result = calculator.calculate

    # 計算結果に必要なキーが含まれていることを確認
    assert_includes result.keys, :procurement_cost
    assert_includes result.keys, :other_costs

    # 原価が正の数であることを確認
    assert result[:procurement_cost] >= 0
    assert result[:other_costs] >= 0
  end
end
