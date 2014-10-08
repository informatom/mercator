class AddStateToProperty < ActiveRecord::Migration
  def self.up
    add_column :properties, :state, :string, :default => "filterable"
    add_column :properties, :key_timestamp, :datetime

    add_index :properties, [:state]
  end

  def self.down
    remove_column :properties, :state
    remove_column :properties, :key_timestamp

    remove_index :properties, :name => :index_properties_on_state rescue ActiveRecord::StatementInvalid
  end
end
