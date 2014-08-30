class AddPhoneNumbers < ActiveRecord::Migration
  def self.up
    add_column :billing_addresses, :phone, :string

    add_column :users, :phone, :string

    add_column :addresses, :phone, :string

    add_column :orders, :billing_phone, :string
    add_column :orders, :shipping_phone, :string

    add_column :offers, :billing_phone, :string
    add_column :offers, :shipping_phone, :string
  end

  def self.down
    remove_column :billing_addresses, :phone

    remove_column :users, :phone

    remove_column :addresses, :phone

    remove_column :orders, :billing_phone
    remove_column :orders, :shipping_phone

    remove_column :offers, :billing_phone
    remove_column :offers, :shipping_phone
  end
end
