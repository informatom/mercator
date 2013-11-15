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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131115063506) do

  create_table "addresses", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "detail"
    t.string   "street"
    t.string   "postalcode"
    t.string   "city"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "addresses", ["user_id"], :name => "index_addresses_on_user_id"

  create_table "categories", :force => true do |t|
    t.string   "name_de"
    t.string   "ancestry"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",         :default => "new"
    t.datetime "key_timestamp"
    t.string   "name_en"
  end

  add_index "categories", ["ancestry"], :name => "index_categories_on_ancestry"
  add_index "categories", ["state"], :name => "index_categories_on_state"

  create_table "categorizations", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
    t.integer  "product_id"
  end

  add_index "categorizations", ["category_id"], :name => "index_categorizations_on_category_id"
  add_index "categorizations", ["product_id"], :name => "index_categorizations_on_product_id"

  create_table "ckeditor_assets", :force => true do |t|
    t.string   "data_file_name",                  :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    :limit => 30
    t.string   "type",              :limit => 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], :name => "idx_ckeditor_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_ckeditor_assetable_type"

  create_table "constants", :force => true do |t|
    t.string   "key"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "content_elements", :force => true do |t|
    t.string   "name_de"
    t.string   "name_en"
    t.text     "content_de"
    t.text     "content_en"
    t.string   "markup"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lineitems", :force => true do |t|
    t.string   "product_number"
    t.integer  "amount"
    t.decimal  "product_price",  :precision => 10, :scale => 2
    t.integer  "vat"
    t.decimal  "value",          :precision => 10, :scale => 2
    t.integer  "position"
    t.string   "description_de"
    t.string   "description_en"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "order_id"
  end

  add_index "lineitems", ["order_id"], :name => "index_lineitems_on_order_id"

  create_table "orders", :force => true do |t|
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
  end

  add_index "orders", ["user_id"], :name => "index_orders_on_user_id"

  create_table "productrelations", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
    t.integer  "related_product_id"
  end

  add_index "productrelations", ["product_id"], :name => "index_productrelations_on_product_id"
  add_index "productrelations", ["related_product_id"], :name => "index_productrelations_on_related_product_id"

  create_table "products", :force => true do |t|
    t.string   "name_de"
    t.string   "number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",                 :default => "new"
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
  end

  add_index "products", ["state"], :name => "index_products_on_state"

  create_table "properties", :force => true do |t|
    t.string   "name_de"
    t.string   "name_en"
    t.decimal  "value"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
    t.integer  "property_group_id"
    t.string   "description_de"
    t.string   "description_en"
    t.string   "unit_de"
    t.string   "unit_en"
  end

  add_index "properties", ["product_id"], :name => "index_properties_on_product_id"
  add_index "properties", ["property_group_id"], :name => "index_properties_on_property_group_id"

  create_table "property_groups", :force => true do |t|
    t.string   "name_de"
    t.string   "name_en"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
  end

  add_index "property_groups", ["product_id"], :name => "index_property_groups_on_product_id"

  create_table "supplyrelations", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
    t.integer  "supply_id"
  end

  add_index "supplyrelations", ["product_id"], :name => "index_supplyrelations_on_product_id"
  add_index "supplyrelations", ["supply_id"], :name => "index_supplyrelations_on_supply_id"

  create_table "users", :force => true do |t|
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "name"
    t.string   "email_address"
    t.boolean  "administrator",                           :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",                                   :default => "active"
    t.datetime "key_timestamp"
  end

  add_index "users", ["state"], :name => "index_users_on_state"

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

end
