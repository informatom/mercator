class AddUsageSqueelConditionToCategory < ActiveRecord::Migration
  def self.up
    add_column :categories, :usage, :string
    add_column :categories, :squeel_condition, :string
  end

  def self.down
    remove_column :categories, :usage
    remove_column :categories, :squeel_condition
  end
end
