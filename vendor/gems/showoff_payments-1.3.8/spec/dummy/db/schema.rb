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

ActiveRecord::Schema.define(version: 20170701152720) do

  create_table "customers", force: :cascade do |t|
    t.string   "email",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "customers", ["email"], name: "index_customers_on_email"

  create_table "purchases", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "showoff_payments_customer_identities", force: :cascade do |t|
    t.integer  "customer_id",         limit: 8,                null: false
    t.string   "customer_type",                                null: false
    t.integer  "vendor_identity_id"
    t.boolean  "active",                        default: true, null: false
    t.text     "provider_identifier",                          null: false
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.integer  "provider_id"
  end

  add_index "showoff_payments_customer_identities", ["active"], name: "showoff_payments_customer_identities_active"
  add_index "showoff_payments_customer_identities", ["customer_id", "customer_type"], name: "showoff_payments_customer_identities_customer"
  add_index "showoff_payments_customer_identities", ["customer_type"], name: "showoff_payments_customer_identities_customer_type"
  add_index "showoff_payments_customer_identities", ["provider_identifier"], name: "showoff_payments_customer_identities_provider_identifier"
  add_index "showoff_payments_customer_identities", ["vendor_identity_id"], name: "showoff_payments_customer_identities_vendor_identity"

  create_table "showoff_payments_providers", force: :cascade do |t|
    t.integer  "name",       default: 0, null: false
    t.string   "slug",                   null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "showoff_payments_providers", ["name"], name: "showoff_payment_providers_name"
  add_index "showoff_payments_providers", ["slug"], name: "showoff_payment_providers_slug"

  create_table "showoff_payments_receipts", force: :cascade do |t|
    t.integer  "status",                         default: 0, null: false
    t.integer  "customer_identity_id",                       null: false
    t.integer  "purchase_id",          limit: 8,             null: false
    t.string   "purchase_type",                              null: false
    t.float    "amount",                                     null: false
    t.float    "application_fee",                            null: false
    t.integer  "credits",                        default: 0, null: false
    t.string   "currency",                                   null: false
    t.integer  "quantity",                       default: 1, null: false
    t.text     "notes"
    t.integer  "address_id"
    t.string   "address_type"
    t.text     "provider_identifier",                        null: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.integer  "vendor_identity_id"
    t.integer  "source_id"
  end

  add_index "showoff_payments_receipts", ["address_id", "address_type"], name: "showoff_payments_receipts_address"
  add_index "showoff_payments_receipts", ["address_id"], name: "index_showoff_payments_receipts_on_address_id"
  add_index "showoff_payments_receipts", ["address_type"], name: "index_showoff_payments_receipts_on_address_type"
  add_index "showoff_payments_receipts", ["credits"], name: "index_showoff_payments_receipts_on_credits"
  add_index "showoff_payments_receipts", ["currency"], name: "index_showoff_payments_receipts_on_currency"
  add_index "showoff_payments_receipts", ["customer_identity_id"], name: "index_showoff_payments_receipts_on_customer_identity_id"
  add_index "showoff_payments_receipts", ["provider_identifier"], name: "index_showoff_payments_receipts_on_provider_identifier"
  add_index "showoff_payments_receipts", ["purchase_id", "purchase_type"], name: "showoff_payments_receipts_purchase"
  add_index "showoff_payments_receipts", ["purchase_type"], name: "index_showoff_payments_receipts_on_purchase_type"
  add_index "showoff_payments_receipts", ["quantity"], name: "index_showoff_payments_receipts_on_quantity"
  add_index "showoff_payments_receipts", ["status"], name: "index_showoff_payments_receipts_on_status"

  create_table "showoff_payments_receipts_vouchers", force: :cascade do |t|
    t.integer "receipt_id"
    t.integer "voucher_id",   null: false
    t.string  "voucher_type", null: false
  end

  add_index "showoff_payments_receipts_vouchers", ["voucher_id", "voucher_type"], name: "showoff_payments_receipts_vouchers_voucher"
  add_index "showoff_payments_receipts_vouchers", ["voucher_id"], name: "index_showoff_payments_receipts_vouchers_on_voucher_id"
  add_index "showoff_payments_receipts_vouchers", ["voucher_type"], name: "index_showoff_payments_receipts_vouchers_on_voucher_type"

  create_table "showoff_payments_refunds", force: :cascade do |t|
    t.integer  "receipt_id",                          null: false
    t.float    "amount",                              null: false
    t.boolean  "application_fee",     default: false, null: false
    t.text     "provider_identifier",                 null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "showoff_payments_refunds", ["provider_identifier"], name: "index_showoff_payments_refunds_on_provider_identifier"
  add_index "showoff_payments_refunds", ["receipt_id"], name: "index_showoff_payments_refunds_on_receipt_id"

  create_table "showoff_payments_sources", force: :cascade do |t|
    t.boolean  "active",               default: true,  null: false
    t.boolean  "default",              default: false, null: false
    t.integer  "customer_identity_id",                 null: false
    t.integer  "vendor_identity_id"
    t.string   "brand",                                null: false
    t.string   "country"
    t.string   "cvc_check"
    t.string   "last_four",                            null: false
    t.integer  "exp_month",                            null: false
    t.integer  "exp_year",                             null: false
    t.text     "provider_identifier",                  null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "showoff_payments_sources", ["active"], name: "showoff_payments_sources_active"
  add_index "showoff_payments_sources", ["brand"], name: "index_showoff_payments_sources_on_brand"
  add_index "showoff_payments_sources", ["country"], name: "index_showoff_payments_sources_on_country"
  add_index "showoff_payments_sources", ["customer_identity_id"], name: "index_showoff_payments_sources_on_customer_identity_id"
  add_index "showoff_payments_sources", ["cvc_check"], name: "index_showoff_payments_sources_on_cvc_check"
  add_index "showoff_payments_sources", ["default"], name: "showoff_payments_sources_default"
  add_index "showoff_payments_sources", ["exp_month"], name: "index_showoff_payments_sources_on_exp_month"
  add_index "showoff_payments_sources", ["exp_year"], name: "index_showoff_payments_sources_on_exp_year"
  add_index "showoff_payments_sources", ["last_four"], name: "index_showoff_payments_sources_on_last_four"
  add_index "showoff_payments_sources", ["provider_identifier"], name: "index_showoff_payments_sources_on_provider_identifier"
  add_index "showoff_payments_sources", ["vendor_identity_id"], name: "index_showoff_payments_sources_on_vendor_identity_id"

  create_table "showoff_payments_vendor_identities", force: :cascade do |t|
    t.integer  "vendor_id",            limit: 8,                null: false
    t.string   "vendor_type",                                   null: false
    t.integer  "provider_id",                                   null: false
    t.boolean  "active",                         default: true, null: false
    t.text     "provider_identifier",                           null: false
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.integer  "vendor_identity_type",           default: 0
    t.text     "provider_secret"
    t.text     "provider_key"
  end

  add_index "showoff_payments_vendor_identities", ["active"], name: "showoff_payments_vendor_identities_active"
  add_index "showoff_payments_vendor_identities", ["provider_id"], name: "showoff_payments_vendor_identities_payment_provider"
  add_index "showoff_payments_vendor_identities", ["provider_identifier"], name: "showoff_payments_vendor_identities_provider_identifier"
  add_index "showoff_payments_vendor_identities", ["vendor_id", "vendor_type"], name: "showoff_payments_vendor_identities_vendor"
  add_index "showoff_payments_vendor_identities", ["vendor_type"], name: "showoff_payments_vendor_identities_vendor_type"

  create_table "showoff_payments_vendor_identity_meta_datas", force: :cascade do |t|
    t.integer  "vendor_identity_id",                                 null: false
    t.text     "country"
    t.text     "default_currency"
    t.text     "currencies_supported"
    t.integer  "identification_status",               default: 0,    null: false
    t.text     "identification_details"
    t.text     "identification_details_code"
    t.text     "identification_provider_identifier"
    t.text     "verification_fields_required"
    t.text     "verification_fields_disabled_reason"
    t.datetime "verification_fields_required_by"
    t.boolean  "payments_charges_enabled",            default: true, null: false
    t.boolean  "payments_transfers_enabled",          default: true, null: false
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
  end

  add_index "showoff_payments_vendor_identity_meta_datas", ["country"], name: "showoff_payments_vendor_identity_meta_datas_country"
  add_index "showoff_payments_vendor_identity_meta_datas", ["currencies_supported"], name: "showoff_payments_vendor_identity_meta_datas_currency_s"
  add_index "showoff_payments_vendor_identity_meta_datas", ["default_currency"], name: "showoff_payments_vendor_identity_meta_datas_currency"
  add_index "showoff_payments_vendor_identity_meta_datas", ["identification_details"], name: "showoff_payments_vendor_identity_meta_datas_id_d"
  add_index "showoff_payments_vendor_identity_meta_datas", ["identification_details_code"], name: "showoff_payments_vendor_identity_meta_datas_id_d_c"
  add_index "showoff_payments_vendor_identity_meta_datas", ["identification_provider_identifier"], name: "showoff_payments_vendor_identity_meta_datas_id_p_i"
  add_index "showoff_payments_vendor_identity_meta_datas", ["identification_status"], name: "showoff_payments_vendor_identity_meta_datas_id_s"
  add_index "showoff_payments_vendor_identity_meta_datas", ["payments_charges_enabled"], name: "showoff_payments_vendor_identity_meta_datas_charges_enabled"
  add_index "showoff_payments_vendor_identity_meta_datas", ["payments_transfers_enabled"], name: "showoff_payments_vendor_identity_meta_datas_transfers_enabled"
  add_index "showoff_payments_vendor_identity_meta_datas", ["vendor_identity_id"], name: "showoff_payments_vendor_identity_meta_datas_vendor_identity"
  add_index "showoff_payments_vendor_identity_meta_datas", ["verification_fields_disabled_reason"], name: "showoff_payments_vendor_identity_meta_datas_v_f_d_r"
  add_index "showoff_payments_vendor_identity_meta_datas", ["verification_fields_required"], name: "showoff_payments_vendor_identity_meta_datas_v_f_r"
  add_index "showoff_payments_vendor_identity_meta_datas", ["verification_fields_required_by"], name: "showoff_payments_vendor_identity_meta_datas_v_f_r_by"

  create_table "vendors", force: :cascade do |t|
    t.string   "email",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "vendors", ["email"], name: "index_vendors_on_email"

end
