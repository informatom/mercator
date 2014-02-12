class AddVatNumberToBillingAddress < ActiveRecord::Migration
  def self.up
    add_column :billing_addresses, :vat_number, :string
  end

  def self.down
    remove_column :billing_addresses, :vat_number
  end
end
