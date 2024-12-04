# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2024_12_05_000001) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "buyers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "currencies", force: :cascade do |t|
    t.string "currency_code", null: false
    t.string "currency_name", null: false
    t.string "currency_symbol"
    t.boolean "is_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["currency_code"], name: "index_currencies_on_currency_code", unique: true
  end

  create_table "expenses", force: :cascade do |t|
    t.integer "year"
    t.integer "month"
    t.string "item_name"
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "manufacturers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_manufacturers_on_name"
  end

  create_table "order_sku_links", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "sku_id", null: false
    t.integer "quantity", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id", "sku_id"], name: "index_order_sku_links_on_order_id_and_sku_id", unique: true
    t.index ["order_id"], name: "index_order_sku_links_on_order_id"
    t.index ["sku_id"], name: "index_order_sku_links_on_sku_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "order_number"
    t.date "sale_date"
    t.bigint "sales_channel_id", null: false
    t.bigint "user_id", null: false
    t.bigint "buyer_id", null: false
    t.string "order_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["buyer_id"], name: "index_orders_on_buyer_id"
    t.index ["order_number"], name: "index_orders_on_order_number"
    t.index ["sales_channel_id"], name: "index_orders_on_sales_channel_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "payment_fees", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "fee_category"
    t.decimal "fee_amount"
    t.index ["order_id"], name: "index_payment_fees_on_order_id"
  end

  create_table "procurements", force: :cascade do |t|
    t.decimal "purchase_price"
    t.decimal "forwarding_fee"
    t.decimal "photo_fee"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "product_id", null: false
    t.index ["product_id", "created_at"], name: "index_procurements_on_product_id_and_created_at"
    t.index ["product_id"], name: "index_procurements_on_product_id"
  end

  create_table "product_categories", force: :cascade do |t|
    t.string "category_name"
    t.text "description"
    t.integer "parent_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "oem_part_number"
    t.boolean "is_oem"
    t.string "domestic_title"
    t.string "international_title"
    t.string "product_status"
    t.bigint "product_categories_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "manufacturer_id", null: false
    t.index ["manufacturer_id"], name: "index_products_on_manufacturer_id"
    t.index ["oem_part_number"], name: "index_products_on_oem_part_number"
    t.index ["product_categories_id"], name: "index_products_on_product_categories_id"
  end

  create_table "sales", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.decimal "net_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "currency_id"
    t.decimal "gross_amount"
    t.index ["currency_id"], name: "index_sales_on_currency_id"
    t.index ["order_id"], name: "index_sales_on_order_id"
  end

  create_table "shipments", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.string "tracking_number"
    t.decimal "customer_international_shipping"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "cpass_trade_id"
    t.index ["order_id"], name: "index_shipments_on_order_id"
  end

  create_table "sku_product_links", force: :cascade do |t|
    t.bigint "sku_id", null: false
    t.bigint "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_sku_product_links_on_product_id"
    t.index ["sku_id", "product_id"], name: "index_sku_product_links_on_sku_id_and_product_id", unique: true
    t.index ["sku_id"], name: "index_sku_product_links_on_sku_id"
  end

  create_table "skus", force: :cascade do |t|
    t.string "sku_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sku_code"], name: "index_skus_on_sku_code"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "profile_picture_url"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "order_sku_links", "orders"
  add_foreign_key "order_sku_links", "skus"
  add_foreign_key "orders", "buyers"
  add_foreign_key "orders", "users"
  add_foreign_key "payment_fees", "orders"
  add_foreign_key "procurements", "products"
  add_foreign_key "products", "manufacturers"
  add_foreign_key "products", "product_categories", column: "product_categories_id"
  add_foreign_key "sales", "currencies"
  add_foreign_key "sales", "orders"
  add_foreign_key "shipments", "orders"
  add_foreign_key "sku_product_links", "products"
  add_foreign_key "sku_product_links", "skus"
end
