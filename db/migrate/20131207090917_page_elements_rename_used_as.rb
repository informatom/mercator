class PageElementsRenameUsedAs < ActiveRecord::Migration
  def self.up
    rename_column :page_elements, :usage, :used_as
  end

  def self.down
    rename_column :page_elements, :used_as, :usage
  end
end
