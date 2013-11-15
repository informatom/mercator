class OrdersLifecycle < ActiveRecord::Migration
  def self.up
    add_column :orders, :state, :string, :default => "basket"
    add_column :orders, :key_timestamp, :datetime

    add_index :orders, [:state]
  end

  def self.down
    remove_column :orders, :state
    remove_column :orders, :key_timestamp

    remove_index :orders, :name => :index_orders_on_state rescue ActiveRecord::StatementInvalid
  end
end
