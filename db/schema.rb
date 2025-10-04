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

ActiveRecord::Schema[8.0].define(version: 2025_09_24_230454) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "billing_profiles", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.bigint "product_id", null: false
    t.string "gateway_customer_id"
    t.string "gateway_type"
    t.datetime "migrated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_billing_profiles_on_customer_id"
    t.index ["product_id"], name: "index_billing_profiles_on_product_id"
  end

  create_table "customers", force: :cascade do |t|
    t.jsonb "external_ids", default: {}, null: false
    t.string "name"
    t.string "email"
    t.string "document", null: false
    t.string "phone"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.string "country", default: "BR"
    t.string "status", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document"], name: "index_customers_on_document", unique: true
    t.index ["email"], name: "index_customers_on_email", unique: true
    t.index ["external_ids"], name: "index_customers_on_external_ids", using: :gin
  end

  create_table "invoice_items", force: :cascade do |t|
    t.bigint "invoice_id", null: false
    t.bigint "product_id", null: false
    t.string "description"
    t.integer "amount_cents"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id"], name: "index_invoice_items_on_invoice_id"
    t.index ["product_id"], name: "index_invoice_items_on_product_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.bigint "subscription_id", null: false
    t.bigint "billing_profile_id", null: false
    t.integer "amount_cents"
    t.date "due_date"
    t.integer "status"
    t.string "gateway_invoice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["billing_profile_id"], name: "index_invoices_on_billing_profile_id"
    t.index ["subscription_id"], name: "index_invoices_on_subscription_id"
  end

  create_table "migration_logs", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.string "old_gateway", null: false
    t.string "new_gateway", null: false
    t.string "new_gateway_customer_id"
    t.datetime "migration_date"
    t.integer "status", default: 0
    t.integer "profiles_migrated", default: 0
    t.datetime "rolled_back_at"
    t.string "rollback_reason"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id", "old_gateway"], name: "index_migration_logs_on_customer_id_and_old_gateway"
    t.index ["customer_id"], name: "index_migration_logs_on_customer_id"
    t.index ["migration_date"], name: "index_migration_logs_on_migration_date"
    t.index ["status"], name: "index_migration_logs_on_status"
  end

  create_table "payment_methods", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.string "kind"
    t.jsonb "external_ids", default: {}, null: false
    t.boolean "default", default: false
    t.jsonb "metadata", default: {}
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id", "kind"], name: "index_payment_methods_on_customer_id_and_kind", unique: true
    t.index ["customer_id"], name: "index_payment_methods_on_customer_id"
    t.index ["external_ids"], name: "index_payment_methods_on_external_ids", using: :gin
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "invoice_id", null: false
    t.bigint "billing_profile_id", null: false
    t.string "gateway_payment_id"
    t.integer "amount_cents"
    t.integer "status"
    t.integer "payment_method"
    t.datetime "processed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["billing_profile_id"], name: "index_payments_on_billing_profile_id"
    t.index ["gateway_payment_id"], name: "index_payments_on_gateway_payment_id", unique: true
    t.index ["invoice_id"], name: "index_payments_on_invoice_id"
  end

  create_table "plans", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.string "interval", default: "month", null: false
    t.integer "interval_count", default: 1, null: false
    t.string "billing_type", default: "prepaid", null: false
    t.jsonb "payment_methods", default: []
    t.integer "trial_period_days", default: 0
    t.integer "minimum_price_cents", default: 0
    t.string "status", default: "active", null: false
    t.jsonb "external_ids", default: {}
    t.bigint "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_plans_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.text "description"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_products_on_code", unique: true
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "billing_profile_id", null: false
    t.bigint "plan_id", null: false
    t.bigint "payment_method_id"
    t.string "gateway_subscription_id"
    t.integer "status"
    t.jsonb "external_ids", default: {}
    t.datetime "started_at"
    t.datetime "ended_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["billing_profile_id"], name: "index_subscriptions_on_billing_profile_id"
    t.index ["external_ids"], name: "index_subscriptions_on_external_ids", using: :gin
    t.index ["gateway_subscription_id"], name: "index_subscriptions_on_gateway_subscription_id", unique: true
    t.index ["payment_method_id"], name: "index_subscriptions_on_payment_method_id"
    t.index ["plan_id"], name: "index_subscriptions_on_plan_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "billing_profiles", "customers"
  add_foreign_key "billing_profiles", "products"
  add_foreign_key "invoice_items", "invoices"
  add_foreign_key "invoice_items", "products"
  add_foreign_key "invoices", "billing_profiles"
  add_foreign_key "invoices", "subscriptions"
  add_foreign_key "migration_logs", "customers"
  add_foreign_key "payment_methods", "customers"
  add_foreign_key "payments", "billing_profiles"
  add_foreign_key "payments", "invoices"
  add_foreign_key "plans", "products"
  add_foreign_key "subscriptions", "billing_profiles"
  add_foreign_key "subscriptions", "plans"
end
