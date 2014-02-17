class CreateLinks < ActiveRecord::Migration
  def self.up
    create_table :links do |t|
      t.string   :url
      t.text     :title
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :conversation_id
    end
    add_index :links, [:conversation_id]
  end

  def self.down
    drop_table :links
  end
end
