class AddLoginCountAndLoggedInAtToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :logged_in_at, :datetime
    add_column :users, :login_count, :integer
  end

  def self.down
    remove_column :users, :logged_in_at
    remove_column :users, :login_count
  end
end
