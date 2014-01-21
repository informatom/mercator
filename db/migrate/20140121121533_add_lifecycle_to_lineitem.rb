class AddLifecycleToLineitem < ActiveRecord::Migration
  def self.up
    add_column :lineitems, :state, :string, :default => "active"
    add_column :lineitems, :key_timestamp, :datetime

    add_index :lineitems, [:state]
  end

  def self.down
    remove_column :lineitems, :state
    remove_column :lineitems, :key_timestamp

    remove_index :lineitems, :name => :index_lineitems_on_state rescue ActiveRecord::StatementInvalid
  end
end
