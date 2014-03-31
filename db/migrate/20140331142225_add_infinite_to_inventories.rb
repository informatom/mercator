class AddInfiniteToInventories < ActiveRecord::Migration
  def self.up
    add_column :inventories, :infinite, :boolean
  end

  def self.down
    remove_column :inventories, :infinite
  end
end
