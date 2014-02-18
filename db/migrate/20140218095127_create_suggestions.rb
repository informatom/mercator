class CreateSuggestions < ActiveRecord::Migration
  def self.up
    create_table :suggestions do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :conversation_id
      t.integer  :product_id
    end
    add_index :suggestions, [:conversation_id]
    add_index :suggestions, [:product_id]
  end

  def self.down
    drop_table :suggestions
  end
end
