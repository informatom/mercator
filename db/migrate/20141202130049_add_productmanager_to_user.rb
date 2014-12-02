class AddProductmanagerToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :productmanager, :boolean, :default => false
  end

  def self.down
    remove_column :users, :productmanager
  end
end
