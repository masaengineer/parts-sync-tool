class OrdersController < ApplicationController
    # 注文全体のデータ
    @orders_data = @orders.map do |order|
      order_revenue = order.sale&.order_net_amount.to_f
      order_payment_fees = order.payment_fees.sum(&:fee_amount)
      order_shipping_cost = order.shipment&.customer_international_shipping.to_f

      # SKUごとの売上・原価取得
      # SKUにはsku_net_amountとquantityがあり、原価はprocurementsから取得
      sku_total_procurement_cost = 0
      sku_total_revenue = 0

      order.skus.each do |sku|
        sku_revenue = sku.sku_net_amount * sku.quantity
        sku_procurement = sku.procurements.sum { |p| p.purchase_price + p.forwarding_fee + p.photo_fee }
        sku_total_procurement_cost += sku_procurement
        sku_total_revenue += sku_revenue
      end

      # 注文全体でのコスト合計
      total_cost = order_payment_fees + order_shipping_cost + sku_total_procurement_cost
      profit = order_revenue - total_cost
      profit_rate = order_revenue.zero? ? 0 : (profit / order_revenue) * 100

      {
        order: order,
        revenue: order_revenue,
        payment_fees: order_payment_fees,
        shipping_cost: order_shipping_cost,
        procurement_cost: sku_total_procurement_cost,
        profit: profit,
        profit_rate: profit_rate,
        quantity: total_quantity
      }
    end

    # SKU単位のデータ
    @skus_data = @orders.flat_map do |order|
      order.skus.map do |sku|
        sku_revenue = sku.sku_net_amount * sku.quantity
        sku_procurement_cost = sku.procurements.sum { |p| p.purchase_price + p.forwarding_fee + p.photo_fee }
        sku_profit = sku_revenue - sku_procurement_cost
        sku_profit_rate = sku_revenue.zero? ? 0 : (sku_profit / sku_revenue) * 100

        {
          order: order,
          sku: sku,
          revenue: sku_revenue,
          procurement_cost: sku_procurement_cost,
          profit: sku_profit,
          profit_rate: sku_profit_rate
        }
      end
    end
end
