class AddressesAddIndexOnUser < ActiveRecord::Migration
  def self.up
    add_index :addresses, [:user_id]
  end

  def self.down
    remove_index :addresses, :name => :index_addresses_on_user_id rescue ActiveRecord::StatementInvalid
  end
end
