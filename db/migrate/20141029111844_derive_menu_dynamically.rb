class DeriveMenuDynamically < ActiveRecord::Migration
  def self.up
    remove_column :webpages, :menu
  end

  def self.down
    add_column :webpages, :menu, :boolean
  end
end
