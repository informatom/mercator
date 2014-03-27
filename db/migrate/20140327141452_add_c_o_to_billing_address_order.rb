class AddCOToBillingAddressOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :billing_c_o, :string
    add_column :orders, :shipping_c_o, :string

    add_column :billing_addresses, :c_o, :string
  end

  def self.down
    remove_column :orders, :billing_c_o
    remove_column :orders, :shipping_c_o

    remove_column :billing_addresses, :c_o
  end
end
