class AddFilterminAndFiltermaxToCategory < ActiveRecord::Migration
  def self.up
    add_column :categories, :filtermin, :decimal, :precision => 10, :scale => 2
    add_column :categories, :filtermax, :decimal, :precision => 10, :scale => 2
  end

  def self.down
    remove_column :categories, :filtermin
    remove_column :categories, :filtermax
  end
end
