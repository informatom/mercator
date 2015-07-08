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

ActiveRecord::Schema.define(version: 20150707073443) do

  create_table "addresses", force: true do |t|
    t.integer  "user_id"
    t.string   "company"
    t.string   "detail"
    t.string   "street"
    t.string   "postalcode"
    t.string   "city"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "state",         default: "active"
    t.datetime "key_timestamp"
    t.string   "surname"
    t.string   "gender"
    t.string   "title"
    t.string   "first_name"
    t.string   "phone"
  end

  add_index "addresses", ["state"], name: "index_addresses_on_state", using: :btree
  add_index "addresses", ["user_id"], name: "index_addresses_on_user_id", using: :btree

  create_table "ahoy_events", force: true do |t|
    t.uuid     "visit_id"
    t.integer  "user_id"
    t.string   "name"
    t.text     "properties"
    t.datetime "time"
  end

  add_index "ahoy_events", ["time"], name: "index_ahoy_events_on_time", using: :btree
  add_index "ahoy_events", ["user_id"], name: "index_ahoy_events_on_user_id", using: :btree
  add_index "ahoy_events", ["visit_id"], name: "index_ahoy_events_on_visit_id", using: :btree

  create_table "billing_addresses", force: true do |t|
    t.string   "company"
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
    t.string   "vat_number"
    t.string   "surname"
    t.string   "gender"
    t.string   "title"
    t.string   "first_name"
    t.string   "phone"
  end

  add_index "billing_addresses", ["state"], name: "index_billing_addresses_on_state", using: :btree
  add_index "billing_addresses", ["user_id"], name: "index_billing_addresses_on_user_id", using: :btree

  create_table "blogposts", force: true do |t|
    t.string   "title_de"
    t.string   "title_en"
    t.date     "publishing_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "content_element_id"
    t.integer  "post_category_id"
  end

  add_index "blogposts", ["content_element_id"], name: "index_blogposts_on_content_element_id", using: :btree
  add_index "blogposts", ["post_category_id"], name: "index_blogposts_on_post_category_id", using: :btree

  create_table "categories", force: true do |t|
    t.string   "name_de"
    t.string   "ancestry"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",                                          default: "new"
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
    t.text     "filters"
    t.decimal  "filtermin",             precision: 10, scale: 2
    t.decimal  "filtermax",             precision: 10, scale: 2
    t.string   "erp_identifier"
    t.string   "usage"
    t.string   "squeel_condition"
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

  create_table "chapters", force: true do |t|
    t.string   "start"
    t.string   "title"
    t.string   "href"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "podcast_id"
  end

  add_index "chapters", ["podcast_id"], name: "index_chapters_on_podcast_id", using: :btree

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

  create_table "comments", force: true do |t|
    t.text     "content"
    t.string   "ancestry"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "blogpost_id"
    t.integer  "podcast_id"
  end

  add_index "comments", ["ancestry"], name: "index_comments_on_ancestry", using: :btree
  add_index "comments", ["blogpost_id"], name: "index_comments_on_blogpost_id", using: :btree
  add_index "comments", ["podcast_id"], name: "index_comments_on_podcast_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "constants", force: true do |t|
    t.string   "key"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "consumableitems", force: true do |t|
    t.integer  "position"
    t.string   "product_number"
    t.string   "product_line"
    t.string   "description_de"
    t.string   "description_en"
    t.integer  "amount"
    t.integer  "theyield"
    t.decimal  "wholesale_price", precision: 13, scale: 5
    t.integer  "term"
    t.integer  "consumption1"
    t.integer  "consumption2"
    t.integer  "consumption3"
    t.integer  "consumption4"
    t.integer  "consumption5"
    t.integer  "consumption6"
    t.decimal  "balance6",        precision: 13, scale: 5
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "contractitem_id"
    t.string   "contract_type"
  end

  add_index "consumableitems", ["contractitem_id"], name: "index_consumableitems_on_contractitem_id", using: :btree

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
    t.integer  "folder_id"
  end

  add_index "content_elements", ["folder_id"], name: "index_content_elements_on_folder_id", using: :btree

  create_table "contractitems", force: true do |t|
    t.string   "product_number"
    t.string   "description_de"
    t.string   "description_en"
    t.integer  "amount"
    t.string   "unit"
    t.decimal  "product_price",   precision: 13, scale: 5
    t.decimal  "vat",             precision: 10, scale: 2
    t.decimal  "value",           precision: 13, scale: 5
    t.decimal  "discount_abs",    precision: 10, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "contract_id"
    t.integer  "position"
    t.integer  "product_id"
    t.integer  "toner_id"
    t.integer  "volume"
    t.integer  "term"
    t.date     "startdate"
    t.integer  "volume_bw"
    t.integer  "volume_color"
    t.decimal  "marge",           precision: 13, scale: 5
    t.decimal  "monitoring_rate", precision: 13, scale: 5
  end

  add_index "contractitems", ["contract_id"], name: "index_contractitems_on_contract_id", using: :btree
  add_index "contractitems", ["product_id"], name: "index_contractitems_on_product_id", using: :btree
  add_index "contractitems", ["toner_id"], name: "index_contractitems_on_toner_id", using: :btree
  add_index "contractitems", ["user_id"], name: "index_contractitems_on_user_id", using: :btree

  create_table "contracts", force: true do |t|
    t.date     "startdate"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "customer_id"
    t.integer  "consultant_id"
    t.integer  "conversation_id"
    t.integer  "term"
  end

  add_index "contracts", ["consultant_id"], name: "index_contracts_on_consultant_id", using: :btree
  add_index "contracts", ["conversation_id"], name: "index_contracts_on_conversation_id", using: :btree
  add_index "contracts", ["customer_id"], name: "index_contracts_on_customer_id", using: :btree

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

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

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

  create_table "feedbacks", force: true do |t|
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "consultant_id"
    t.integer  "conversation_id"
  end

  add_index "feedbacks", ["consultant_id"], name: "index_feedbacks_on_consultant_id", using: :btree
  add_index "feedbacks", ["conversation_id"], name: "index_feedbacks_on_conversation_id", using: :btree
  add_index "feedbacks", ["user_id"], name: "index_feedbacks_on_user_id", using: :btree

  create_table "folders", force: true do |t|
    t.string   "name"
    t.string   "ancestry"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "folders", ["ancestry"], name: "index_folders_on_ancestry", using: :btree

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "gtcs", force: true do |t|
    t.string   "title_de"
    t.string   "title_en"
    t.text     "content_de"
    t.text     "content_en"
    t.date     "version_of"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "markup"
  end

  create_table "inventories", force: true do |t|
    t.string   "name_de"
    t.string   "name_en"
    t.string   "number"
    t.decimal  "amount",                  precision: 10, scale: 2
    t.string   "unit"
    t.string   "comment_de"
    t.string   "comment_en"
    t.decimal  "weight",                  precision: 10, scale: 2
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
    t.datetime "erp_updated_at"
    t.integer  "erp_vatline"
    t.integer  "erp_article_group"
    t.integer  "erp_provision_code"
    t.integer  "erp_characteristic_flag"
    t.boolean  "infinite"
    t.boolean  "just_imported"
    t.string   "alternative_number"
    t.string   "size"
  end

  add_index "inventories", ["product_id"], name: "index_inventories_on_product_id", using: :btree

  create_table "lineitems", force: true do |t|
    t.string   "product_number"
    t.decimal  "amount",         precision: 10, scale: 2
    t.decimal  "product_price",  precision: 13, scale: 5
    t.decimal  "vat",            precision: 10, scale: 2
    t.decimal  "value",          precision: 13, scale: 5
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
    t.boolean  "upselling"
    t.decimal  "discount_abs",   precision: 13, scale: 5, default: 0.0
    t.integer  "inventory_id"
  end

  add_index "lineitems", ["inventory_id"], name: "index_lineitems_on_inventory_id", using: :btree
  add_index "lineitems", ["order_id"], name: "index_lineitems_on_order_id", using: :btree
  add_index "lineitems", ["product_id"], name: "index_lineitems_on_product_id", using: :btree
  add_index "lineitems", ["state"], name: "index_lineitems_on_state", using: :btree
  add_index "lineitems", ["user_id"], name: "index_lineitems_on_user_id", using: :btree

  create_table "links", force: true do |t|
    t.string   "url"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "conversation_id"
  end

  add_index "links", ["conversation_id"], name: "index_links_on_conversation_id", using: :btree

  create_table "logentries", force: true do |t|
    t.string   "severity"
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "logentries", ["user_id"], name: "index_logentries_on_user_id", using: :btree

  create_table "mercator_icecat_metadata", force: true do |t|
    t.string   "path"
    t.datetime "icecat_updated_at"
    t.string   "quality"
    t.string   "product_number"
    t.string   "cat_id"
    t.string   "on_market"
    t.string   "model_name"
    t.string   "product_view"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
    t.string   "supplier_id"
    t.string   "icecat_product_id"
    t.string   "prod_id"
  end

  add_index "mercator_icecat_metadata", ["icecat_product_id"], name: "index_mercator_icecat_metadata_on_icecat_product_id", using: :btree
  add_index "mercator_icecat_metadata", ["prod_id"], name: "index_mercator_icecat_metadata_on_prod_id", using: :btree
  add_index "mercator_icecat_metadata", ["product_id"], name: "index_mercator_icecat_metadata_on_product_id", using: :btree

  create_table "mercator_mpay24_confirmations", force: true do |t|
    t.string   "operation"
    t.string   "tid"
    t.string   "status"
    t.string   "price"
    t.string   "currency"
    t.string   "p_type"
    t.string   "brand"
    t.string   "mpaytid"
    t.string   "user_field"
    t.string   "orderdesc"
    t.string   "customer"
    t.string   "customer_email"
    t.string   "language"
    t.string   "customer_id"
    t.string   "profile_id"
    t.string   "profile_status"
    t.string   "filter_status"
    t.string   "appr_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "payment_id"
  end

  add_index "mercator_mpay24_confirmations", ["payment_id"], name: "index_mercator_mpay24_confirmations_on_payment_id", using: :btree

  create_table "mercator_mpay24_payments", force: true do |t|
    t.string   "merchant_id"
    t.string   "tid"
    t.text     "order_xml"
    t.integer  "order_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_field_hash"
  end

  add_index "mercator_mpay24_payments", ["order_id"], name: "index_mercator_mpay24_payments_on_order_id", using: :btree

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

  create_table "offeritems", force: true do |t|
    t.string   "product_number"
    t.string   "description_de"
    t.string   "description_en"
    t.decimal  "amount",         precision: 10, scale: 2
    t.string   "unit"
    t.decimal  "product_price",  precision: 13, scale: 5
    t.decimal  "vat",            precision: 10, scale: 2
    t.decimal  "value",          precision: 13, scale: 5
    t.string   "delivery_time"
    t.boolean  "upselling"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "offer_id"
    t.integer  "position"
    t.integer  "product_id"
    t.string   "state",                                   default: "in_progress"
    t.datetime "key_timestamp"
    t.decimal  "discount_abs",   precision: 13, scale: 5, default: 0.0
  end

  add_index "offeritems", ["offer_id"], name: "index_offeritems_on_offer_id", using: :btree
  add_index "offeritems", ["product_id"], name: "index_offeritems_on_product_id", using: :btree
  add_index "offeritems", ["state"], name: "index_offeritems_on_state", using: :btree
  add_index "offeritems", ["user_id"], name: "index_offeritems_on_user_id", using: :btree

  create_table "offers", force: true do |t|
    t.string   "billing_company"
    t.string   "billing_detail"
    t.string   "billing_street"
    t.string   "billing_postalcode"
    t.string   "billing_city"
    t.string   "billing_country"
    t.string   "shipping_company"
    t.string   "shipping_detail"
    t.string   "shipping_street"
    t.string   "shipping_postalcode"
    t.string   "shipping_city"
    t.string   "shipping_country"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "consultant_id"
    t.integer  "conversation_id"
    t.string   "state",                                        default: "in_progress"
    t.datetime "key_timestamp"
    t.date     "valid_until"
    t.boolean  "complete"
    t.decimal  "discount_rel",        precision: 13, scale: 5, default: 0.0
    t.string   "billing_surname"
    t.string   "shipping_surname"
    t.string   "billing_gender"
    t.string   "billing_title"
    t.string   "billing_first_name"
    t.string   "shipping_gender"
    t.string   "shipping_title"
    t.string   "shipping_first_name"
    t.string   "billing_phone"
    t.string   "shipping_phone"
  end

  add_index "offers", ["consultant_id"], name: "index_offers_on_consultant_id", using: :btree
  add_index "offers", ["conversation_id"], name: "index_offers_on_conversation_id", using: :btree
  add_index "offers", ["state"], name: "index_offers_on_state", using: :btree
  add_index "offers", ["user_id"], name: "index_offers_on_user_id", using: :btree

  create_table "orders", force: true do |t|
    t.string   "billing_method"
    t.string   "billing_company"
    t.string   "billing_detail"
    t.string   "billing_street"
    t.string   "billing_postalcode"
    t.string   "billing_city"
    t.string   "billing_country"
    t.string   "shipping_method"
    t.string   "shipping_company"
    t.string   "shipping_detail"
    t.string   "shipping_street"
    t.string   "shipping_postalcode"
    t.string   "shipping_city"
    t.string   "shipping_country"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "state",                                        default: "basket"
    t.datetime "key_timestamp"
    t.integer  "conversation_id"
    t.datetime "gtc_confirmed_at"
    t.date     "gtc_version_of"
    t.string   "erp_customer_number"
    t.string   "erp_billing_number"
    t.string   "erp_order_number"
    t.string   "billing_surname"
    t.string   "shipping_surname"
    t.decimal  "discount_rel",        precision: 13, scale: 5, default: 0.0
    t.string   "billing_gender"
    t.string   "billing_title"
    t.string   "billing_first_name"
    t.string   "shipping_gender"
    t.string   "shipping_title"
    t.string   "shipping_first_name"
    t.string   "billing_phone"
    t.string   "shipping_phone"
    t.string   "store"
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
    t.boolean  "dryml"
  end

  create_table "podcasts", force: true do |t|
    t.integer  "number"
    t.string   "title"
    t.text     "shownotes"
    t.string   "duration"
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mp3_file_name"
    t.string   "mp3_content_type"
    t.integer  "mp3_file_size"
    t.datetime "mp3_updated_at"
    t.string   "ogg_file_name"
    t.string   "ogg_content_type"
    t.integer  "ogg_file_size"
    t.datetime "ogg_updated_at"
  end

  create_table "post_categories", force: true do |t|
    t.string   "name_de"
    t.string   "name_en"
    t.string   "ancestry"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "post_categories", ["ancestry"], name: "index_post_categories_on_ancestry", using: :btree

  create_table "prices", force: true do |t|
    t.decimal  "value",        precision: 13, scale: 5
    t.decimal  "vat",          precision: 10, scale: 2
    t.date     "valid_from"
    t.date     "valid_to"
    t.decimal  "scale_from",   precision: 10, scale: 2
    t.decimal  "scale_to",     precision: 10, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "inventory_id"
    t.boolean  "promotion"
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
    t.string   "title_de"
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
    t.string   "title_en"
    t.integer  "legacy_id"
    t.text     "long_description_de"
    t.text     "long_description_en"
    t.text     "warranty_de"
    t.text     "warranty_en"
    t.boolean  "not_shippable"
    t.string   "alternative_number"
  end

  add_index "products", ["state"], name: "index_products_on_state", using: :btree

  create_table "properties", force: true do |t|
    t.string   "name_de"
    t.string   "name_en"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "legacy_id"
    t.string   "datatype"
    t.integer  "icecat_id"
    t.string   "state",         default: "filterable"
    t.datetime "key_timestamp"
  end

  add_index "properties", ["icecat_id"], name: "index_properties_on_icecat_id", using: :btree
  add_index "properties", ["state"], name: "index_properties_on_state", using: :btree

  create_table "property_groups", force: true do |t|
    t.string   "name_de"
    t.string   "name_en"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "icecat_id"
  end

  add_index "property_groups", ["icecat_id"], name: "index_property_groups_on_icecat_id", using: :btree

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

  create_table "shipping_costs", force: true do |t|
    t.string   "shipping_method"
    t.decimal  "value",           precision: 13, scale: 5
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "country_id"
    t.decimal  "vat",             precision: 10, scale: 2
  end

  add_index "shipping_costs", ["country_id"], name: "index_shipping_costs_on_country_id", using: :btree

  create_table "submissions", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.text     "message"
    t.string   "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "suggestions", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "conversation_id"
    t.integer  "product_id"
  end

  add_index "suggestions", ["conversation_id"], name: "index_suggestions_on_conversation_id", using: :btree
  add_index "suggestions", ["product_id"], name: "index_suggestions_on_product_id", using: :btree

  create_table "supplyrelations", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
    t.integer  "supply_id"
  end

  add_index "supplyrelations", ["product_id"], name: "index_supplyrelations_on_product_id", using: :btree
  add_index "supplyrelations", ["supply_id"], name: "index_supplyrelations_on_supply_id", using: :btree

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "toners", force: true do |t|
    t.string   "article_number"
    t.string   "description"
    t.string   "vendor_number"
    t.decimal  "price",          precision: 13, scale: 5
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "crypted_password",          limit: 40
    t.string   "salt",                      limit: 40
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "surname"
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
    t.boolean  "sales_manager",                        default: false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "erp_contact_nr"
    t.string   "erp_account_nr"
    t.string   "locale"
    t.string   "gender"
    t.string   "title"
    t.string   "first_name"
    t.string   "phone"
    t.integer  "call_priority"
    t.boolean  "contentmanager",                       default: false
    t.boolean  "productmanager",                       default: false
    t.string   "editor"
    t.boolean  "waiting"
  end

  add_index "users", ["erp_account_nr"], name: "index_users_on_erp_account_nr", using: :btree
  add_index "users", ["state"], name: "index_users_on_state", using: :btree

  create_table "values", force: true do |t|
    t.string   "title_de"
    t.string   "title_en"
    t.decimal  "amount",            precision: 10, scale: 2
    t.boolean  "flag"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "property_group_id"
    t.integer  "property_id"
    t.integer  "product_id"
    t.string   "state",                                      default: "textual"
    t.datetime "key_timestamp"
    t.string   "unit_de"
    t.string   "unit_en"
  end

  add_index "values", ["product_id"], name: "index_values_on_product_id", using: :btree
  add_index "values", ["property_group_id"], name: "index_values_on_property_group_id", using: :btree
  add_index "values", ["property_id"], name: "index_values_on_property_id", using: :btree
  add_index "values", ["state"], name: "index_values_on_state", using: :btree

  create_table "versions", force: true do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  create_table "visits", force: true do |t|
    t.uuid     "visitor_id"
    t.string   "ip"
    t.text     "user_agent"
    t.text     "referrer"
    t.text     "landing_page"
    t.integer  "user_id"
    t.string   "referring_domain"
    t.string   "search_keyword"
    t.string   "browser"
    t.string   "os"
    t.string   "device_type"
    t.string   "country"
    t.string   "region"
    t.string   "city"
    t.string   "utm_source"
    t.string   "utm_medium"
    t.string   "utm_term"
    t.string   "utm_content"
    t.string   "utm_campaign"
    t.datetime "started_at"
  end

  add_index "visits", ["user_id"], name: "index_visits_on_user_id", using: :btree

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
    t.string   "slug"
    t.string   "seo_description"
  end

  add_index "webpages", ["ancestry"], name: "index_webpages_on_ancestry", using: :btree
  add_index "webpages", ["page_template_id"], name: "index_webpages_on_page_template_id", using: :btree
  add_index "webpages", ["state"], name: "index_webpages_on_state", using: :btree

end
