class AddLifecycleToAddress < ActiveRecord::Migration
  def self.up
    add_column :addresses, :state, :string, :default => "active"
    add_column :addresses, :key_timestamp, :datetime

    add_index :addresses, [:state]
  end

  def self.down
    remove_column :addresses, :state
    remove_column :addresses, :key_timestamp

    remove_index :addresses, :name => :index_addresses_on_state rescue ActiveRecord::StatementInvalid
  end
end
