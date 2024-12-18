require 'csv'

class EbaySalesReportImporter
  def initialize(csv_path)
    @csv_path = csv_path
  end

  def import
    csv = CSV.read(@csv_path, headers: true)
    csv.each do |row|
      order_number = row["Order Number"]&.strip
      next if order_number.nil? || order_number.empty?

      tracking_number = row["Tracking Number"]&.strip
      next if tracking_number.nil? || tracking_number.empty?

      # Orderが存在しなければ新規作成
      # 既にebaytransactionreportで作成済みならfindで取得される
      order = Order.find_or_create_by!(order_number: order_number)
      # トラッキングナンバー更新
      order.update!(tracking_number: tracking_number)
    end
  end
end
