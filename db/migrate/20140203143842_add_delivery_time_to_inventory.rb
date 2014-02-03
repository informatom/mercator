class AddDeliveryTimeToInventory < ActiveRecord::Migration
  def self.up
    add_column :inventories, :delivery_time, :string
  end

  def self.down
    remove_column :inventories, :delivery_time
  end
end
