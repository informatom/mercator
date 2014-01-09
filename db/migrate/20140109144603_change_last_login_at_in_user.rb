class ChangeLastLoginAtInUser < ActiveRecord::Migration
  def self.up
    rename_column :users, :logged_in_at, :last_login_at
  end

  def self.down
    rename_column :users, :last_login_at, :logged_in_at
  end
end
