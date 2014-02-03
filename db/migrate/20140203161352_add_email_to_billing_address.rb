class AddEmailToBillingAddress < ActiveRecord::Migration
  def self.up
    add_column :billing_addresses, :email_address, :string
  end

  def self.down
    remove_column :billing_addresses, :email_address
  end
end
