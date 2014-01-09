class AddLoggedInToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :logged_in, :boolean, :default => false
    change_column :users, :login_count, :integer, :limit => 4, :default => 0
  end

  def self.down
    remove_column :users, :logged_in
    change_column :users, :login_count, :integer
  end
end
