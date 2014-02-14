class AddSalesManagerToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :sales_manager, :boolean, :default => false
  end

  def self.down
    remove_column :users, :sales_manager
  end
end
