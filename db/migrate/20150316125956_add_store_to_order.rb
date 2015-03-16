class AddStoreToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :store, :string
  end

  def self.down
    remove_column :orders, :store
  end
end
