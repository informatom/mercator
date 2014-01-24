class AddLifecycleToBillingAddress < ActiveRecord::Migration
  def self.up
    add_column :billing_addresses, :state, :string, :default => "active"
    add_column :billing_addresses, :key_timestamp, :datetime

    add_index :billing_addresses, [:state]
  end

  def self.down
    remove_column :billing_addresses, :state
    remove_column :billing_addresses, :key_timestamp

    remove_index :billing_addresses, :name => :index_billing_addresses_on_state rescue ActiveRecord::StatementInvalid
  end
end
