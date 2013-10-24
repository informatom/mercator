class HoboMigration4 < ActiveRecord::Migration
  def self.up
    remove_column :categories, :active
  end

  def self.down
    add_column :categories, :active, :boolean
  end
end
