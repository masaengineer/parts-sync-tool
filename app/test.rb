
-----------
rails db:migrate:reset
user = User.first
fulfillment = Ebay::FulfillmentService.new
fetched_orders = fulfillment.fetch_orders(user)
File.write("orders.json", JSON.pretty_generate(fetched_orders))
importer = Ebay::TransactionFeeImporter.new
imported_data = importer.import



---
importer = Ebay::TransactionFeeImporter.new
log_output = importer.import # ログ出力を取得
File.write("finance.json", log_output) # ログをファイルに書き込む

