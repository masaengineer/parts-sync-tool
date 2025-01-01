module SalesReportsHelper
  def table_columns
    [
      { key: :sale_date },
      { key: :order_number, class: 'whitespace-nowrap' },
      { key: :sku, class: 'max-w-[200px] truncate' },
      { key: :product_name, class: 'max-w-[200px] truncate' },
      { key: :revenue_dollar, class: 'text-right' },
      { key: :fee_dollar, header_class: 'text-right', cell_class: 'text-right text-error' },
      { key: :shipping_yen, header_class: 'text-right', cell_class: 'text-right text-error' },
      { key: :procurement_yen, header_class: 'text-right', cell_class: 'text-right text-error' },
      { key: :other_cost_yen, header_class: 'text-right', cell_class: 'text-right text-error' },
      { key: :quantity, class: 'text-right font-medium' },
      { key: :profit_yen, class: 'text-right font-bold text-success' },
      { key: :profit_rate, class: 'text-right font-medium' },
      { key: :tracking_number, class: 'whitespace-nowrap font-medium' }
    ]
  end

  def render_cell_value(data, column)
    case column[:key]
    when :sale_date
      l(data[:sale_date], format: :default) if data[:sale_date]
    when :order_number
      data[:order].order_number
    when :sku
      content_tag(:span, data[:sku_codes], title: data[:sku_codes])
    when :product_name
      content_tag(:span, data[:product_names], title: data[:product_names])
    when :revenue_dollar
      number_to_currency(data[:revenue], unit: '$', precision: 2, format: '%u%n')
    when :fee_dollar
      number_to_currency(data[:payment_fees], unit: '$', precision: 2, format: '%u%n')
    when :shipping_yen, :procurement_yen, :other_cost_yen
      cost_key = {
        shipping_yen: :shipping_cost,
        procurement_yen: :procurement_cost,
        other_cost_yen: :other_costs
      }[column[:key]]
      number_to_currency(data[cost_key], unit: '¥', precision: 0, format: '%u%n')
    when :quantity
      data[:quantity]
    when :profit_yen
      number_to_currency(data[:profit], unit: '¥', precision: 0, format: '%u%n')
    when :profit_rate
      "#{number_with_precision(data[:profit_rate], precision: 1)}%"
    when :tracking_number
      data[:tracking_number]
    end
  end

  def get_column_class(column, type = :cell)
    return column[:class] if column[:class]
    type == :header ? column[:header_class] : column[:cell_class]
  end
end
