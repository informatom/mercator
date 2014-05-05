class AddBillingCOShippingCOToOffer < ActiveRecord::Migration
  def self.up
    add_column :offers, :billing_c_o, :string
    add_column :offers, :shipping_c_o, :string
  end

  def self.down
    remove_column :offers, :billing_c_o
    remove_column :offers, :shipping_c_o
  end
end
