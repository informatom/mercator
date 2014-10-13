class AddContentManagerToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :contentmanager, :boolean, :default => false
  end

  def self.down
    remove_column :users, :contentmanager
  end
end
