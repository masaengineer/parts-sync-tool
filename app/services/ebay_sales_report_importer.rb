require "csv"

class EbaySalesReportImporter
  def initialize(csv_path, user)
    @csv_path = csv_path
    @user = user
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
      order = @user.orders.find_or_create_by!(order_number: order_number)

      # Orderに紐づくShipmentを検索、存在しなければ新規作成
      shipment = order.shipment || order.build_shipment
      # トラッキングナンバー更新
      shipment.tracking_number = tracking_number
      shipment.save!
    end
  end
end
