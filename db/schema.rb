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

ActiveRecord::Schema[7.0].define(version: 2023_06_16_062342) do
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

  create_table "characteristics", force: :cascade do |t|
    t.string "title"
    t.integer "property_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.decimal "totalsum", precision: 12, scale: 2
    t.string "status"
    t.string "tip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "line_items", force: :cascade do |t|
    t.integer "incase_id"
    t.string "title"
    t.integer "quantity"
    t.string "katnumber"
    t.decimal "price", precision: 12, scale: 2
    t.decimal "sum", precision: 12, scale: 2
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "okrugs", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "places", force: :cascade do |t|
    t.string "sector"
    t.string "cell"
    t.integer "product_id"
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
    t.decimal "costprice"
    t.decimal "price"
    t.string "video"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "properties", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "props", force: :cascade do |t|
    t.integer "product_id"
    t.integer "property_id"
    t.integer "characteristic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "detal_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "warehouses", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
