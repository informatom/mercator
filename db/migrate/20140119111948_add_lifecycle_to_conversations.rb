class AddLifecycleToConversations < ActiveRecord::Migration
  def self.up
    add_column :conversations, :state, :string, :default => "active"
    add_column :conversations, :key_timestamp, :datetime

    add_index :conversations, [:state]
  end

  def self.down
    remove_column :conversations, :state
    remove_column :conversations, :key_timestamp

    remove_index :conversations, :name => :index_conversations_on_state rescue ActiveRecord::StatementInvalid
  end
end
