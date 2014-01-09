class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.string   :content
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :sender_id
      t.integer  :reciever_id
      t.integer  :conversation_id
    end
    add_index :messages, [:sender_id]
    add_index :messages, [:reciever_id]
    add_index :messages, [:conversation_id]
  end

  def self.down
    drop_table :messages
  end
end
