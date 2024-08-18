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

ActiveRecord::Schema[7.1].define(version: 2024_08_08_120010) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.integer "position", default: 1
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.jsonb "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "characteristics", force: :cascade do |t|
    t.string "title"
    t.integer "property_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["title"], name: "index_characteristics_on_title"
  end

  create_table "client_companies", force: :cascade do |t|
    t.integer "client_id"
    t.integer "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clients", force: :cascade do |t|
    t.string "surname"
    t.string "name"
    t.string "middlename"
    t.string "phone"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.string "commentable_type"
    t.integer "commentable_id"
    t.integer "user_id"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "inn"
    t.string "kpp"
    t.string "title"
    t.string "ur_address"
    t.string "fact_address"
    t.string "ogrn"
    t.string "okpo"
    t.string "bik"
    t.string "bank_title"
    t.string "bank_account"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tip"
    t.string "short_title"
    t.integer "okrug_id"
  end

  create_table "company_plan_dates", force: :cascade do |t|
    t.datetime "date"
    t.integer "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dashboards", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "delivery_types", force: :cascade do |t|
    t.string "title"
    t.decimal "price"
    t.string "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position", default: 1, null: false
  end

  create_table "detal_props", force: :cascade do |t|
    t.bigint "property_id", null: false
    t.bigint "characteristic_id", null: false
    t.bigint "detal_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["characteristic_id"], name: "index_detal_props_on_characteristic_id"
    t.index ["detal_id"], name: "index_detal_props_on_detal_id"
    t.index ["property_id"], name: "index_detal_props_on_property_id"
  end

  create_table "detals", force: :cascade do |t|
    t.string "sku"
    t.string "title"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "email_setups", force: :cascade do |t|
    t.string "address"
    t.integer "port"
    t.string "domain"
    t.string "authentication"
    t.string "user_name"
    t.string "user_password"
    t.boolean "tls"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "enter_items", force: :cascade do |t|
    t.bigint "enter_id", null: false
    t.bigint "product_id", null: false
    t.integer "quantity"
    t.decimal "price"
    t.integer "vat"
    t.decimal "sum"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["enter_id"], name: "index_enter_items_on_enter_id"
    t.index ["product_id"], name: "index_enter_items_on_product_id"
  end

  create_table "enter_statuses", force: :cascade do |t|
    t.string "title"
    t.string "color"
    t.integer "position", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "enters", force: :cascade do |t|
    t.bigint "enter_status_id", null: false
    t.string "title"
    t.datetime "date"
    t.bigint "warehouse_id", null: false
    t.integer "manager_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "stock_transfer_id"
    t.index ["enter_status_id"], name: "index_enters_on_enter_status_id"
    t.index ["warehouse_id"], name: "index_enters_on_warehouse_id"
  end

  create_table "exports", force: :cascade do |t|
    t.string "title"
    t.string "link"
    t.text "template"
    t.string "time"
    t.string "format"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "excel_attributes"
    t.boolean "use_property"
    t.boolean "test", default: true
  end

  create_table "images", force: :cascade do |t|
    t.integer "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position", default: 1, null: false

    t.unique_constraint ["product_id", "position"], deferrable: :deferred, name: "unique_product_id_position"
  end

  create_table "incase_import_columns", force: :cascade do |t|
    t.integer "incase_import_id"
    t.string "column_file"
    t.string "column_system"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "incase_imports", force: :cascade do |t|
    t.boolean "active"
    t.string "title"
    t.string "report"
    t.string "file"
    t.string "uniq_field"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "check", default: false
  end

  create_table "incase_item_statuses", force: :cascade do |t|
    t.string "title"
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position", default: 1, null: false
  end

  create_table "incase_items", force: :cascade do |t|
    t.integer "incase_id"
    t.string "title"
    t.integer "quantity"
    t.string "katnumber"
    t.decimal "price", precision: 12, scale: 2, default: "0.0"
    t.decimal "sum", precision: 12, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "incase_item_status_id"
    t.integer "product_id"
  end

  create_table "incase_statuses", force: :cascade do |t|
    t.string "title"
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position", default: 1, null: false
  end

  create_table "incase_tips", force: :cascade do |t|
    t.string "title"
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position", default: 1, null: false
  end

  create_table "incases", force: :cascade do |t|
    t.string "region"
    t.integer "strah_id"
    t.string "stoanumber"
    t.string "unumber"
    t.integer "company_id"
    t.string "carnumber"
    t.datetime "date"
    t.string "modelauto"
    t.decimal "totalsum", precision: 12, scale: 2, default: "0.0"
    t.string "incase_status_id"
    t.string "incase_tip_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inventory_statuses", force: :cascade do |t|
    t.string "title"
    t.string "color"
    t.integer "position", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invoice_items", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.decimal "price", precision: 12, scale: 2
    t.integer "discount"
    t.decimal "sum", precision: 12, scale: 2
    t.integer "quantity"
    t.integer "vat"
    t.bigint "invoice_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id"], name: "index_invoice_items_on_invoice_id"
    t.index ["product_id"], name: "index_invoice_items_on_product_id"
  end

  create_table "invoice_statuses", force: :cascade do |t|
    t.string "title"
    t.string "color"
    t.integer "position", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invoices", force: :cascade do |t|
    t.integer "company_id"
    t.string "number"
    t.integer "invoice_status_id"
    t.integer "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "client_id", null: false
    t.index ["client_id"], name: "index_invoices_on_client_id"
  end

  create_table "locations", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "place_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "placement_id"
    t.index ["place_id"], name: "index_locations_on_place_id"
    t.index ["placement_id"], name: "index_locations_on_placement_id"
    t.index ["product_id"], name: "index_locations_on_product_id"
  end

  create_table "loss_items", force: :cascade do |t|
    t.bigint "loss_id", null: false
    t.bigint "product_id", null: false
    t.integer "quantity"
    t.decimal "price", precision: 12, scale: 2
    t.integer "vat"
    t.decimal "sum", precision: 12, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["loss_id"], name: "index_loss_items_on_loss_id"
    t.index ["product_id"], name: "index_loss_items_on_product_id"
  end

  create_table "loss_statuses", force: :cascade do |t|
    t.string "title"
    t.string "color"
    t.integer "position", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "losses", force: :cascade do |t|
    t.bigint "loss_status_id", null: false
    t.string "title"
    t.datetime "date"
    t.bigint "warehouse_id", null: false
    t.integer "manager_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "stock_transfer_id"
    t.index ["loss_status_id"], name: "index_losses_on_loss_status_id"
    t.index ["warehouse_id"], name: "index_losses_on_warehouse_id"
  end

  create_table "noticed_events", force: :cascade do |t|
    t.string "type"
    t.string "record_type"
    t.bigint "record_id"
    t.jsonb "params"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "notifications_count"
    t.index ["record_type", "record_id"], name: "index_noticed_events_on_record"
  end

  create_table "noticed_notifications", force: :cascade do |t|
    t.string "type"
    t.bigint "event_id", null: false
    t.string "recipient_type", null: false
    t.bigint "recipient_id", null: false
    t.datetime "read_at", precision: nil
    t.datetime "seen_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_noticed_notifications_on_event_id"
    t.index ["recipient_type", "recipient_id"], name: "index_noticed_notifications_on_recipient"
  end

  create_table "okrugs", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
  end

  create_table "order_items", force: :cascade do |t|
    t.integer "product_id"
    t.decimal "price", precision: 12, scale: 2
    t.integer "discount"
    t.decimal "sum", precision: 12, scale: 2
    t.integer "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quantity"
    t.integer "vat", default: 0, null: false
  end

  create_table "order_statuses", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "color"
    t.integer "position", default: 1, null: false
  end

  create_table "orders", force: :cascade do |t|
    t.string "client_id"
    t.string "manager_id"
    t.string "payment_type_id"
    t.string "delivery_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order_status_id"
    t.bigint "company_id"
    t.index ["company_id"], name: "index_orders_on_company_id"
  end

  create_table "payment_types", force: :cascade do |t|
    t.string "title"
    t.string "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "margin", default: 0
    t.integer "position", default: 1, null: false
  end

  create_table "permissions", force: :cascade do |t|
    t.string "pmodel"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "pactions", default: [], array: true
  end

  create_table "placements", force: :cascade do |t|
    t.bigint "warehouse_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["warehouse_id"], name: "index_placements_on_warehouse_id"
  end

  create_table "places", force: :cascade do |t|
    t.string "sector"
    t.string "cell"
    t.integer "warehouse_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "sku"
    t.string "barcode"
    t.string "title"
    t.string "description"
    t.integer "quantity"
    t.decimal "costprice", precision: 12, scale: 2
    t.decimal "price", precision: 12, scale: 2
    t.string "video"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "draft", null: false
    t.string "tip", default: "product", null: false
  end

  create_table "properties", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["title"], name: "index_properties_on_title"
  end

  create_table "props", force: :cascade do |t|
    t.integer "property_id"
    t.integer "characteristic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "product_id"
    t.index ["characteristic_id"], name: "index_props_on_characteristic_id"
    t.index ["product_id"], name: "index_props_on_product_id"
    t.index ["property_id"], name: "index_props_on_property_id"
  end

  create_table "rent_case_statuses", force: :cascade do |t|
    t.string "title"
    t.string "color"
    t.integer "position", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "return_items", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.decimal "price", precision: 12, scale: 2
    t.integer "discount"
    t.decimal "sum", precision: 12, scale: 2
    t.integer "quantity"
    t.integer "vat"
    t.bigint "return_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_return_items_on_product_id"
    t.index ["return_id"], name: "index_return_items_on_return_id"
  end

  create_table "return_statuses", force: :cascade do |t|
    t.string "title"
    t.string "color"
    t.integer "position", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "returns", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.bigint "company_id", null: false
    t.string "number"
    t.bigint "return_status_id", null: false
    t.bigint "invoice_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_returns_on_client_id"
    t.index ["company_id"], name: "index_returns_on_company_id"
    t.index ["invoice_id"], name: "index_returns_on_invoice_id"
    t.index ["return_status_id"], name: "index_returns_on_return_status_id"
  end

  create_table "stock_transfer_items", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "stock_transfer_id", null: false
    t.integer "quantity"
    t.decimal "price"
    t.integer "vat"
    t.decimal "sum"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_stock_transfer_items_on_product_id"
    t.index ["stock_transfer_id"], name: "index_stock_transfer_items_on_stock_transfer_id"
  end

  create_table "stock_transfer_statuses", force: :cascade do |t|
    t.string "title"
    t.string "color"
    t.integer "position", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stock_transfers", force: :cascade do |t|
    t.bigint "stock_transfer_status_id", null: false
    t.integer "origin_warehouse_id", null: false
    t.integer "destination_warehouse_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stock_transfer_status_id"], name: "index_stock_transfers_on_stock_transfer_status_id"
  end

  create_table "stocks", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "user_id", null: false
    t.string "stockable_type", null: false
    t.bigint "stockable_id", null: false
    t.string "move"
    t.integer "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_stocks_on_product_id"
    t.index ["stockable_type", "stockable_id"], name: "index_stocks_on_stockable"
    t.index ["user_id"], name: "index_stocks_on_user_id"
  end

  create_table "supplies", force: :cascade do |t|
    t.integer "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.string "in_number"
    t.datetime "in_date"
    t.integer "supply_status_id"
    t.integer "manager_id"
    t.integer "warehouse_id"
  end

  create_table "supply_items", force: :cascade do |t|
    t.integer "supply_id"
    t.integer "product_id"
    t.integer "quantity", default: 0
    t.decimal "price", precision: 12, scale: 2
    t.decimal "sum", precision: 12, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "vat", default: 0, null: false
  end

  create_table "supply_statuses", force: :cascade do |t|
    t.string "title"
    t.string "color"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "templs", force: :cascade do |t|
    t.string "title"
    t.string "subject"
    t.string "receiver"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tip"
    t.string "modelname"
  end

  create_table "trigger_actions", force: :cascade do |t|
    t.string "name"
    t.string "value", null: false
    t.integer "trigger_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "triggers", force: :cascade do |t|
    t.string "title"
    t.string "event"
    t.string "condition"
    t.boolean "pause"
    t.string "pause_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role"
    t.string "name"
    t.string "phone"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "warehouses", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position", default: 1, null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "detal_props", "characteristics"
  add_foreign_key "detal_props", "detals"
  add_foreign_key "detal_props", "properties"
  add_foreign_key "enter_items", "enters"
  add_foreign_key "enter_items", "products"
  add_foreign_key "enters", "enter_statuses"
  add_foreign_key "enters", "warehouses"
  add_foreign_key "invoice_items", "invoices"
  add_foreign_key "invoice_items", "products"
  add_foreign_key "invoices", "clients"
  add_foreign_key "locations", "placements"
  add_foreign_key "locations", "places"
  add_foreign_key "locations", "products"
  add_foreign_key "loss_items", "losses"
  add_foreign_key "loss_items", "products"
  add_foreign_key "losses", "loss_statuses"
  add_foreign_key "losses", "warehouses"
  add_foreign_key "orders", "companies"
  add_foreign_key "placements", "warehouses"
  add_foreign_key "props", "products"
  add_foreign_key "return_items", "products"
  add_foreign_key "return_items", "returns"
  add_foreign_key "returns", "clients"
  add_foreign_key "returns", "companies"
  add_foreign_key "returns", "invoices"
  add_foreign_key "returns", "return_statuses"
  add_foreign_key "stock_transfer_items", "products"
  add_foreign_key "stock_transfer_items", "stock_transfers"
  add_foreign_key "stock_transfers", "stock_transfer_statuses"
  add_foreign_key "stocks", "products"
  add_foreign_key "stocks", "users"
end
