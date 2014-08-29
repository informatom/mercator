class AddFirstnameTitleGenderToOffer < ActiveRecord::Migration
  def self.up
    rename_column :offers, :billing_name, :billing_company
    rename_column :offers, :shipping_name, :shipping_company
    rename_column :offers, :billing_c_o, :billing_surname
    rename_column :offers, :shipping_c_o, :shipping_surname
    add_column :offers, :billing_gender, :string
    add_column :offers, :billing_title, :string
    add_column :offers, :billing_first_name, :string
    add_column :offers, :shipping_gender, :string
    add_column :offers, :shipping_title, :string
    add_column :offers, :shipping_first_name, :string
  end

  def self.down
    rename_column :offers, :billing_company, :billing_name
    rename_column :offers, :shipping_company, :shipping_name
    rename_column :offers, :billing_surname, :billing_c_o
    rename_column :offers, :shipping_surname, :shipping_c_o
    remove_column :offers, :billing_gender
    remove_column :offers, :billing_title
    remove_column :offers, :billing_first_name
    remove_column :offers, :shipping_gender
    remove_column :offers, :shipping_title
    remove_column :offers, :shipping_first_name
  end
end
