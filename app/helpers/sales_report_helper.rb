module SalesReportHelper
  # 検索フォームの入力フィールドを生成するヘルパーメソッド
  def search_form_field(form, field_name, label_text, options = {})
    field_type = options[:field_type] || :search_field
    input_classes = "input input-bordered w-full focus:input-primary"
    label_classes = "label font-medium"

    content_tag(:div, class: "form-control w-full") do
      concat form.label(field_name, label_text, class: label_classes)
      concat form.send(field_type, field_name, class: input_classes)
    end
  end

  # 検索フォームのフィールド設定を返すメソッド
  def search_form_fields
    [
      { name: :order_number_cont, label: "注文番号" },
      { name: :shipment_tracking_number_cont, label: "追跡番号" },
      { name: :order_sku_links_sku_sku_code_cont, label: "SKUコード" },
      { name: :sale_date_gteq, label: "販売日（から）", field_type: :date_field },
      { name: :sale_date_lteq, label: "販売日（まで）", field_type: :date_field }
    ]
  end
end
