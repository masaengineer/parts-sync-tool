class DataImportsController < ApplicationController
  def import
    file = params[:file]
    import_type = params[:import_type]

    if file.blank?
      redirect_to sales_reports_path, alert: "ファイルを選択してください。" and return
    end

    begin
      case import_type
      when "filtered_data_sheet"
        FilteredDataSheetImporter.new(file.path).import
        flash[:notice] = "Filtered Data Sheetのインポートが完了しました。"
      when "ebay_sales_report"
        EbaySalesReportImporter.new(file.path).import
        flash[:notice] = "eBay Sales Reportのインポートが完了しました。"
      when "cpass_shipping_cost"
        CpassShippingCostImporter.new(file.path).import
        flash[:notice] = "Cpass Shipping Costのインポートが完了しました。"
      when "ebay_transaction_report"
        EbayTransactionReportImporter.new(file.path).import
        flash[:notice] = "eBay Transaction Reportのインポートが完了しました。"
      else
        flash[:alert] = "不明なインポートタイプです。"
      end
    rescue FilteredDataSheetImporter::MissingSkusError => e
      flash[:alert] = "インポートエラー: #{e.message}"
    rescue CpassShippingCostImporter::PositiveDiscountError => e
      flash[:alert] = "インポートエラー: #{e.message}"
    rescue StandardError => e
      flash[:alert] = case e.message
      when /undefined method.*nil/
        "CSVファイルの形式が正しくないか、必要なデータが含まれていません。"
      when /CSVファイルの処理中/
        e.message
      else
        "予期せぬエラーが発生しました: #{e.message}"
      end
    end

    redirect_to sales_reports_path
  end
end
