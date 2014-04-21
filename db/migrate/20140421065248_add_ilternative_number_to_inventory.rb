class AddIlternativeNumberToInventory < ActiveRecord::Migration
  def self.up
    add_column :inventories, :alternative_number, :string
  end

  def self.down
    remove_column :inventories, :alternative_number
  end
end
