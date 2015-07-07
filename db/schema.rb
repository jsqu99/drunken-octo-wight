# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150701203344) do

  create_table "billing_address", force: :cascade do |t|
    t.string "fake_string", null: false
  end

  create_table "carts", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "currency",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "credit_cards", force: :cascade do |t|
    t.string   "name_on_card",                          null: false
    t.string   "month",                                 null: false
    t.string   "year",                                  null: false
    t.string   "last_digits",                 limit: 4, null: false
    t.integer  "billing_address_id",                    null: false
    t.string   "gateway_customer_profile_id"
    t.string   "gateway_payment_profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoice_adjustments", force: :cascade do |t|
    t.integer  "invoice_id",                      null: false
    t.string   "type",                            null: false
    t.string   "description",                     null: false
    t.integer  "amount_cents",    default: 0,     null: false
    t.string   "amount_currency", default: "USD", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoices", force: :cascade do |t|
    t.integer "order_id",                       null: false
    t.integer "total_cents",    default: 0,     null: false
    t.string  "total_currency", default: "USD", null: false
  end

  create_table "line_item_customizations", force: :cascade do |t|
    t.integer  "line_item_id"
    t.integer  "customizable_id",   null: false
    t.string   "customizable_type", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "line_items", force: :cascade do |t|
    t.integer  "product_id",                          null: false
    t.integer  "cart_id"
    t.integer  "quantity",                            null: false
    t.integer  "unit_price_cents",    default: 0,     null: false
    t.string   "unit_price_currency", default: "USD", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "cart_id", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.integer  "invoice_id",                      null: false
    t.integer  "source_id"
    t.string   "source_type"
    t.string   "transaction_id"
    t.integer  "amount_cents",    default: 0,     null: false
    t.string   "amount_currency", default: "USD", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_prices", force: :cascade do |t|
    t.integer "product_id"
    t.integer "price_cents",    default: 0,     null: false
    t.string  "price_currency", default: "USD", null: false
  end

  add_index "product_prices", ["product_id"], name: "index_product_prices_on_product_id"

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shipping_addresses", force: :cascade do |t|
    t.string "fake_string", null: false
  end

end
