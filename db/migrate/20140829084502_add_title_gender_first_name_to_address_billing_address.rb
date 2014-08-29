class AddTitleGenderFirstNameToAddressBillingAddress < ActiveRecord::Migration
  def self.up
    add_column :billing_addresses, :gender, :string
    add_column :billing_addresses, :title, :string
    add_column :billing_addresses, :first_name, :string

    add_column :addresses, :gender, :string
    add_column :addresses, :title, :string
    add_column :addresses, :first_name, :string
  end

  def self.down
    remove_column :billing_addresses, :gender
    remove_column :billing_addresses, :title
    remove_column :billing_addresses, :first_name

    remove_column :addresses, :gender
    remove_column :addresses, :title
    remove_column :addresses, :first_name
  end
end
