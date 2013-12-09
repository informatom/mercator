class UsersAddSales < ActiveRecord::Migration
  def self.up
    add_column :users, :sales, :boolean, :default => false
  end

  def self.down
    remove_column :users, :sales
  end
end
