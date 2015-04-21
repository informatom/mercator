class AddWaitingToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :waiting, :boolean
  end

  def self.down
    remove_column :users, :waiting
  end
end
