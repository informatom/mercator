class AddLogentries < ActiveRecord::Migration
  def self.up
    create_table :logentries do |t|
      t.string   :severity
      t.string   :message
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :user_id
    end
    add_index :logentries, [:user_id]
  end

  def self.down
    drop_table :logentries
  end
end
