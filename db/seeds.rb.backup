# db/seeds.rb

# 依存するもの（子）から順に削除していく
OrderSkuLink.delete_all
PaymentFee.delete_all
Procurement.delete_all
Sale.delete_all
Shipment.delete_all
Expense.delete_all
Sku.delete_all
Order.delete_all
User.delete_all
Manufacturer.delete_all

# ここから再作成

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

# 2. Manufacturer
manufacturer = Manufacturer.create!(name: "Example Manufacturer")

# 3. SKU
skus = 30.times.map do |i|
  Sku.create!(
    sku_code: "SKU-#{i+1}",
    quantity: rand(10..100),
    sku_net_amount: rand(10..100) + rand.round(2),
    sku_gross_amount: rand(10..150) + rand.round(2),
    international_title: "Product #{i+1}",
    manufacturer: manufacturer
  )
end

# 4. Order
orders = 30.times.map do |i|
  Order.create!(
    order_number: "ORDER-#{1000+i}",
    sale_date: Date.today - i.days
  )
end

# 5. OrderSkuLink
30.times do |i|
  OrderSkuLink.create!(
    order: orders[i],
    sku: skus.sample
  )
end

# 6. PaymentFee
30.times do |i|
  PaymentFee.create!(
    order: orders[i],
    fee_category: "Transaction Fee #{i+1}",
    fee_amount: rand(1..10) + rand.round(2)
  )
end

# 7. Procurement
30.times do |i|
  Procurement.create!(
    sku: skus.sample,
    purchase_price: rand(1..50) + rand.round(2),
    forwarding_fee: rand(1..5) + rand.round(2),
    photo_fee: rand(0.5..2.0).round(2)
  )
end

# 8. Sale
30.times do |i|
  Sale.create!(
    order: orders[i],
    order_net_amount: (50 + i*2).to_f,
    order_gross_amount: (60 + i*2.5).to_f
  )
end

# 9. Shipment
30.times do |i|
  Shipment.create!(
    order: orders[i],
    customer_international_shipping: rand(5..20) + rand.round(2),
    cpass_trade_id: 1000 + i,
    tracking_number: "TRACK-#{i+1000}"
  )
end

# 10. Expense
30.times do |i|
  Expense.create!(
    year: 2024,
    month: (i % 12) + 1,
    item_name: "Office Supplies #{i+1}",
    amount: rand(10..500) + rand.round(2)
  )
end

puts "Seeding completed successfully!"
