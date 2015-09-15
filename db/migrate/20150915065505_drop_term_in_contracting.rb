class DropTermInContracting < ActiveRecord::Migration
  def self.up
    remove_column :consumableitems, :term
    remove_column :contractitems, :term
    remove_column :contracts, :term
  end

  def self.down
    add_column :consumableitems, :term, :integer, default: 0
    add_column :contractitems, :term, :integer, default: 0
    add_column :contracts, :term, :integer, default: 0
  end
end
