class AddSizeToInventory < ActiveRecord::Migration
  def self.up
    add_column :inventories, :size, :string
  end

  def self.down
    remove_column :inventories, :size
  end
end
