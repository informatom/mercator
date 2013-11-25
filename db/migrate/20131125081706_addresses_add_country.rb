class AddressesAddCountry < ActiveRecord::Migration
  def self.up
    add_column :addresses, :country, :string
  end

  def self.down
    remove_column :addresses, :country
  end
end
