class AddFiltersToCategory < ActiveRecord::Migration
  def self.up
    add_column :categories, :filters, :text
  end

  def self.down
    remove_column :categories, :filters
  end
end
