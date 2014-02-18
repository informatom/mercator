class CreateOffersAndOfferitems < ActiveRecord::Migration
  def self.up
    create_table :offers do |t|
      t.string   :billing_name
      t.string   :billing_detail
      t.string   :billing_street
      t.string   :billing_postalcode
      t.string   :billing_city
      t.string   :billing_country
      t.string   :shipping_name
      t.string   :shipping_detail
      t.string   :shipping_street
      t.string   :shipping_postalcode
      t.string   :shipping_city
      t.string   :shipping_country
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :user_id
      t.integer  :consultant_id
      t.integer  :conversation_id
      t.string   :state, :default => "in_progress"
      t.datetime :key_timestamp
    end
    add_index :offers, [:user_id]
    add_index :offers, [:consultant_id]
    add_index :offers, [:conversation_id]
    add_index :offers, [:state]

    create_table :offeritems do |t|
      t.string   :product_number
      t.string   :description_de
      t.string   :description_en
      t.decimal  :amount, :precision => 10, :scale => 2
      t.string   :unit
      t.decimal  :product_price, :scale => 2, :precision => 10
      t.decimal  :vat, :precision => 10, :scale => 2
      t.decimal  :value, :scale => 2, :precision => 10
      t.string   :delivery_time
      t.boolean  :upselling
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :user_id
      t.integer  :offer_id
      t.integer  :position
      t.integer  :product_id
      t.string   :state, :default => "active"
      t.datetime :key_timestamp
    end
    add_index :offeritems, [:user_id]
    add_index :offeritems, [:offer_id]
    add_index :offeritems, [:product_id]
    add_index :offeritems, [:state]
  end

  def self.down
    drop_table :offers
    drop_table :offeritems
  end
end
