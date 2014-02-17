class ChangeLinkTitleToString < ActiveRecord::Migration
  def self.up
    change_column :links, :title, :string, :limit => 255
  end

  def self.down
    change_column :links, :title, :text
  end
end
