# This migration comes from mercator_mesonic (originally 20140319161842)
class AddErpUpdatedAtToInventory < ActiveRecord::Migration
  def self.up
    add_column :inventories, :erp_updated_at, :datetime
  end

  def self.down
    remove_column :inventories, :erp_updated_at
  end
end
