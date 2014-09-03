class AddCallPriorityToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :call_priority, :integer
  end

  def self.down
    remove_column :users, :call_priority
  end
end
