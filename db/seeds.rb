# db/seeds.rb

# Clear existing data (開発用の例、必要に応じてコメントアウト)
User.delete_all
Manufacturer.delete_all
Product.delete_all
Sku.delete_all
SkuProductLink.delete_all
Order.delete_all
OrderSkuLink.delete_all
PaymentFee.delete_all
Procurement.delete_all
Sale.delete_all
Shipment.delete_all
Expense.delete_all

# 1. ユーザー30件作成
30.times do |i|
  User.create!(
    email: "user#{i}@example.com",
    first_name: "FirstName#{i}",
    last_name: "LastName#{i}",
    password: "password",
    profile_picture_url: nil
  )
end

# 2. Manufacturer作成(30件)
manufacturers = 30.times.map do |i|
  Manufacturer.create!(
    name: "Manufacturer #{i+1}"
  )
end

# 3. Product作成(30件)
# ランダムなManufacturerを紐付け
products = 30.times.map do |i|
  Product.create!(
    oem_part_number: "PN-#{i+1}",
    international_title: "Product #{i+1}",
    manufacturer: manufacturers.sample
  )
end

# 4. SKU作成 (30件)
skus = 30.times.map do |i|
  Sku.create!(
    sku_code: "SKU-#{i+1}",
    quantity: rand(10..100),
    sku_net_amount: rand(10..100) + rand.round(2),
    sku_gross_amount: rand(10..150) + rand.round(2)
  )
end

# 5. SKUとProductの関連付け(SkuProductLink)
# シンプルに i番目のproductとi番目のskuを1対1でリンクする例
30.times do |i|
  SkuProductLink.create!(
    sku: skus[i],
    product: products[i]
  )
end

# 6. Order作成(30件)
orders = 30.times.map do |i|
  Order.create!(
    order_number: "ORDER-#{1000+i}",
    sale_date: Date.today - i.days
  )
end

# 7. OrderとSKUの関連付け (OrderSkuLink: 30件)
# ランダムSKUを1つリンク(複数可)
30.times do |i|
  OrderSkuLink.create!(
    order: orders[i],
    sku: skus.sample
  )
end

# 8. PaymentFee作成 (30件: 各Orderに1つ紐づける)
30.times do |i|
  PaymentFee.create!(
    order: orders[i],
    fee_category: "Transaction Fee #{i+1}",
    fee_amount: rand(1..10) + rand.round(2)
  )
end

# 9. Procurement作成 (30件: SKUに紐付け)
30.times do |i|
  Procurement.create!(
    sku: skus.sample,
    purchase_price: rand(1..50) + rand.round(2),
    forwarding_fee: rand(1..5) + rand.round(2),
    photo_fee: rand(0.5..2.0).round(2)
  )
end

# 10. Sale作成 (30件: Orderに紐づけ)
30.times do |i|
  Sale.create!(
    order: orders[i],
    order_net_amount: (50 + i*2).to_f,
    order_gross_amount: (60 + i*2.5).to_f
  )
end

# 11. Shipment作成 (30件: Orderに紐づけ)
30.times do |i|
  Shipment.create!(
    order: orders[i],
    tracking_number: "TRACK-#{i+1000}",
    customer_international_shipping: rand(5..20) + rand.round(2),
    cpass_trade_id: 1000 + i
  )
end

# 12. Expense作成 (30件)
30.times do |i|
  Expense.create!(
    year: 2024,
    month: (i % 12) + 1,
    item_name: "Office Supplies #{i+1}",
    amount: rand(10..500) + rand.round(2)
  )
end

puts "Seeding completed successfully!"
