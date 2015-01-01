class AddComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.text     :content
      t.string   :ancestry
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :user_id
      t.integer  :blogpost_id
    end
    add_index :comments, [:ancestry]
    add_index :comments, [:user_id]
    add_index :comments, [:blogpost_id]
  end

  def self.down
    drop_table :comments
  end
end
