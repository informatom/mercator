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

ActiveRecord::Schema.define(version: 20140203161352) do

  create_table "addresses", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "detail"
    t.string   "street"
    t.string   "postalcode"
    t.string   "city"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "state",         default: "active"
    t.datetime "key_timestamp"
  end

  add_index "addresses", ["state"], name: "index_addresses_on_state", using: :btree
  add_index "addresses", ["user_id"], name: "index_addresses_on_user_id", using: :btree

  create_table "billing_addresses", force: true do |t|
    t.string   "name"
    t.string   "detail"
    t.string   "street"
    t.string   "postalcode"
    t.string   "city"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "state",         default: "active"
    t.datetime "key_timestamp"
    t.string   "email_address"
  end

  add_index "billing_addresses", ["state"], name: "index_billing_addresses_on_state", using: :btree
  add_index "billing_addresses", ["user_id"], name: "index_billing_addresses_on_user_id", using: :btree

  create_table "categories", force: true do |t|
    t.string   "name_de"
    t.string   "ancestry"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",                 default: "new"
    t.datetime "key_timestamp"
    t.string   "name_en"
    t.integer  "legacy_id"
    t.text     "description_de"
    t.text     "description_en"
    t.text     "long_description_de"
    t.text     "long_description_en"
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  add_index "categories", ["ancestry"], name: "index_categories_on_ancestry", using: :btree
  add_index "categories", ["state"], name: "index_categories_on_state", using: :btree

  create_table "categorizations", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
    t.integer  "product_id"
    t.integer  "position"
  end

  add_index "categorizations", ["category_id"], name: "index_categorizations_on_category_id", using: :btree
  add_index "categorizations", ["product_id"], name: "index_categorizations_on_product_id", using: :btree

  create_table "ckeditor_assets", force: true do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "constants", force: true do |t|
    t.string   "key"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "content_elements", force: true do |t|
    t.string   "name_de"
    t.string   "name_en"
    t.text     "content_de"
    t.text     "content_en"
    t.string   "markup"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "legacy_id"
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
  end

  create_table "contracts", force: true do |t|
    t.integer  "runtime"
    t.date     "startdate"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "conversations", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "customer_id"
    t.integer  "consultant_id"
    t.string   "state",         default: "active"
    t.datetime "key_timestamp"
  end

  add_index "conversations", ["consultant_id"], name: "index_conversations_on_consultant_id", using: :btree
  add_index "conversations", ["customer_id"], name: "index_conversations_on_customer_id", using: :btree
  add_index "conversations", ["state"], name: "index_conversations_on_state", using: :btree

  create_table "countries", force: true do |t|
    t.string   "name_de"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name_en"
    t.integer  "legacy_id"
  end

  create_table "downloads", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
    t.integer  "conversation_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  add_index "downloads", ["conversation_id"], name: "index_downloads_on_conversation_id", using: :btree

  create_table "features", force: true do |t|
    t.integer  "position"
    t.string   "text_de"
    t.string   "text_en"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
    t.integer  "legacy_id"
  end

  add_index "features", ["product_id"], name: "index_features_on_product_id", using: :btree

  create_table "gtcs", force: true do |t|
    t.string   "title_de"
    t.string   "title_en"
    t.text     "content_de"
    t.text     "content_en"
    t.date     "version_of"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inventories", force: true do |t|
    t.string   "name_de"
    t.string   "name_en"
    t.string   "number"
    t.decimal  "amount",             precision: 10, scale: 2
    t.string   "unit"
    t.string   "comment_de"
    t.string   "comment_en"
    t.decimal  "weight",             precision: 10, scale: 2
    t.string   "charge"
    t.string   "storage"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "delivery_time"
  end

  add_index "inventories", ["product_id"], name: "index_inventories_on_product_id", using: :btree

  create_table "lineitems", force: true do |t|
    t.string   "product_number"
    t.decimal  "amount",         precision: 10, scale: 2
    t.decimal  "product_price",  precision: 10, scale: 2
    t.decimal  "vat",            precision: 10, scale: 2
    t.decimal  "value",          precision: 10, scale: 2
    t.integer  "position"
    t.string   "description_de"
    t.string   "description_en"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "order_id"
    t.string   "unit"
    t.integer  "user_id"
    t.integer  "product_id"
    t.string   "state",                                   default: "active"
    t.datetime "key_timestamp"
    t.string   "delivery_time"
  end

  add_index "lineitems", ["order_id"], name: "index_lineitems_on_order_id", using: :btree
  add_index "lineitems", ["product_id"], name: "index_lineitems_on_product_id", using: :btree
  add_index "lineitems", ["state"], name: "index_lineitems_on_state", using: :btree
  add_index "lineitems", ["user_id"], name: "index_lineitems_on_user_id", using: :btree

  create_table "messages", force: true do |t|
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sender_id"
    t.integer  "reciever_id"
    t.integer  "conversation_id"
  end

  add_index "messages", ["conversation_id"], name: "index_messages_on_conversation_id", using: :btree
  add_index "messages", ["reciever_id"], name: "index_messages_on_reciever_id", using: :btree
  add_index "messages", ["sender_id"], name: "index_messages_on_sender_id", using: :btree

  create_table "orders", force: true do |t|
    t.string   "billing_method"
    t.string   "billing_name"
    t.string   "billing_detail"
    t.string   "billing_street"
    t.string   "billing_postalcode"
    t.string   "billing_city"
    t.string   "billing_country"
    t.string   "shipping_method"
    t.string   "shipping_name"
    t.string   "shipping_detail"
    t.string   "shipping_street"
    t.string   "shipping_postalcode"
    t.string   "shipping_city"
    t.string   "shipping_country"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "state",               default: "basket"
    t.datetime "key_timestamp"
    t.integer  "conversation_id"
    t.datetime "gtc_confirmed_at"
    t.date     "gtc_version_of"
  end

  add_index "orders", ["conversation_id"], name: "index_orders_on_conversation_id", using: :btree
  add_index "orders", ["state"], name: "index_orders_on_state", using: :btree
  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "page_content_element_assignments", force: true do |t|
    t.string   "used_as"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "webpage_id"
    t.integer  "content_element_id"
  end

  add_index "page_content_element_assignments", ["content_element_id"], name: "index_page_content_element_assignments_on_content_element_id", using: :btree
  add_index "page_content_element_assignments", ["webpage_id"], name: "index_page_content_element_assignments_on_webpage_id", using: :btree

  create_table "page_templates", force: true do |t|
    t.string   "name"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "legacy_id"
  end

  create_table "prices", force: true do |t|
    t.decimal  "value",        precision: 10, scale: 2
    t.decimal  "vat",          precision: 10, scale: 2
    t.date     "valid_from"
    t.date     "valid_to"
    t.decimal  "scale_from",   precision: 10, scale: 2
    t.decimal  "scale_to",     precision: 10, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "inventory_id"
  end

  add_index "prices", ["inventory_id"], name: "index_prices_on_inventory_id", using: :btree

  create_table "productrelations", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
    t.integer  "related_product_id"
  end

  add_index "productrelations", ["product_id"], name: "index_productrelations_on_product_id", using: :btree
  add_index "productrelations", ["related_product_id"], name: "index_productrelations_on_related_product_id", using: :btree

  create_table "products", force: true do |t|
    t.string   "name_de"
    t.string   "number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",                 default: "new"
    t.datetime "key_timestamp"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
    t.text     "description_de"
    t.text     "description_en"
    t.string   "name_en"
    t.integer  "legacy_id"
  end

  add_index "products", ["state"], name: "index_products_on_state", using: :btree

  create_table "properties", force: true do |t|
    t.string   "name_de"
    t.string   "name_en"
    t.decimal  "value",             precision: 10, scale: 2
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "property_group_id"
    t.string   "description_de"
    t.string   "description_en"
    t.string   "unit_de"
    t.string   "unit_en"
    t.integer  "legacy_id"
  end

  add_index "properties", ["property_group_id"], name: "index_properties_on_property_group_id", using: :btree

  create_table "property_groups", force: true do |t|
    t.string   "name_de"
    t.string   "name_en"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
  end

  add_index "property_groups", ["product_id"], name: "index_property_groups_on_product_id", using: :btree

  create_table "recommendations", force: true do |t|
    t.string   "reason_de"
    t.string   "reason_en"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
    t.integer  "recommended_product_id"
  end

  add_index "recommendations", ["product_id"], name: "index_recommendations_on_product_id", using: :btree
  add_index "recommendations", ["recommended_product_id"], name: "index_recommendations_on_recommended_product_id", using: :btree

  create_table "supplyrelations", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
    t.integer  "supply_id"
  end

  add_index "supplyrelations", ["product_id"], name: "index_supplyrelations_on_product_id", using: :btree
  add_index "supplyrelations", ["supply_id"], name: "index_supplyrelations_on_supply_id", using: :btree

  create_table "toners", force: true do |t|
    t.string   "article_number"
    t.string   "description"
    t.string   "vendor_number"
    t.decimal  "price",          precision: 10, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "crypted_password",          limit: 40
    t.string   "salt",                      limit: 40
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "name"
    t.string   "email_address"
    t.boolean  "administrator",                        default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",                                default: "inactive"
    t.datetime "key_timestamp"
    t.integer  "legacy_id"
    t.boolean  "sales",                                default: false
    t.datetime "last_login_at"
    t.integer  "login_count",                          default: 0
    t.boolean  "logged_in",                            default: false
    t.datetime "gtc_confirmed_at"
    t.date     "gtc_version_of"
  end

  add_index "users", ["state"], name: "index_users_on_state", using: :btree

  create_table "versions", force: true do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  create_table "webpages", force: true do |t|
    t.string   "title_de"
    t.string   "title_en"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
    t.string   "ancestry"
    t.integer  "position"
    t.integer  "legacy_id"
    t.string   "state",            default: "draft"
    t.datetime "key_timestamp"
    t.integer  "page_template_id"
  end

  add_index "webpages", ["ancestry"], name: "index_webpages_on_ancestry", using: :btree
  add_index "webpages", ["page_template_id"], name: "index_webpages_on_page_template_id", using: :btree
  add_index "webpages", ["state"], name: "index_webpages_on_state", using: :btree
  add_index "webpages", ["url"], name: "index_webpages_on_url", using: :btree

end
