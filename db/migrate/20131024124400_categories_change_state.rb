class CategoriesChangeState < ActiveRecord::Migration
  def self.up
    change_column :categories, :state, :string, :limit => 255, :default => "new"
  end

  def self.down
    change_column :categories, :state, :string
  end
end
