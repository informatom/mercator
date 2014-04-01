class AddJustImportedToInventories < ActiveRecord::Migration
  def self.up
    add_column :inventories, :just_imported, :boolean
  end

  def self.down
    remove_column :inventories, :just_imported
  end
end
