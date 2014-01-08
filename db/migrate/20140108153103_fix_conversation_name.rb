class FixConversationName < ActiveRecord::Migration
  def self.up
    change_column :conversations, :name, :string, :limit => 255
  end

  def self.down
    change_column :conversations, :name, :text
  end
end
