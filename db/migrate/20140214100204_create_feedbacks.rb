class CreateFeedbacks < ActiveRecord::Migration
  def self.up
    create_table :feedbacks do |t|
      t.text     :content
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :user_id
      t.integer  :consultant_id
      t.integer  :conversation_id
    end
    add_index :feedbacks, [:user_id]
    add_index :feedbacks, [:consultant_id]
    add_index :feedbacks, [:conversation_id]
  end

  def self.down
    drop_table :feedbacks
  end
end
