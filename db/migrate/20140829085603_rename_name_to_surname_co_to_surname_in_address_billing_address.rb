class RenameNameToSurnameCoToSurnameInAddressBillingAddress < ActiveRecord::Migration
  def self.up
    rename_column :billing_addresses, :name, :company
    rename_column :billing_addresses, :c_o, :surname

    rename_column :addresses, :name, :company
    rename_column :addresses, :c_o, :surname
  end

  def self.down
    rename_column :billing_addresses, :company, :name
    rename_column :billing_addresses, :surname, :c_o

    rename_column :addresses, :company, :name
    rename_column :addresses, :surname, :c_o
  end
end
