class AddBillingAndShippingGenderTitleFirstNameToOrder < ActiveRecord::Migration
  def self.up
    rename_column :orders, :billing_name, :billing_company
    rename_column :orders, :shipping_name, :shipping_company
    rename_column :orders, :billing_c_o, :billing_surname
    rename_column :orders, :shipping_c_o, :shipping_surname
    add_column :orders, :billing_gender, :string
    add_column :orders, :billing_title, :string
    add_column :orders, :billing_first_name, :string
    add_column :orders, :shipping_gender, :string
    add_column :orders, :shipping_title, :string
    add_column :orders, :shipping_first_name, :string
  end

  def self.down
    rename_column :orders, :billing_company, :billing_name
    rename_column :orders, :shipping_company, :shipping_name
    rename_column :orders, :billing_surname, :billing_c_o
    rename_column :orders, :shipping_surname, :shipping_c_o
    remove_column :orders, :billing_gender
    remove_column :orders, :billing_title
    remove_column :orders, :billing_first_name
    remove_column :orders, :shipping_gender
    remove_column :orders, :shipping_title
    remove_column :orders, :shipping_first_name
  end
end
