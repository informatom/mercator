class AddEditorToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :editor, :string
  end

  def self.down
    remove_column :users, :editor
  end
end
