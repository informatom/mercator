class CreateConversations < ActiveRecord::Migration
  def self.up
    create_table :conversations do |t|
      t.text     :name
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :conversations
  end
end
