class CreateBillingAddresses < ActiveRecord::Migration
  def self.up
    create_table :billing_addresses do |t|
      t.string   :name
      t.string   :detail
      t.string   :street
      t.string   :postalcode
      t.string   :city
      t.string   :country
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :user_id
    end
    add_index :billing_addresses, [:user_id]
  end

  def self.down
    drop_table :billing_addresses
  end
end
