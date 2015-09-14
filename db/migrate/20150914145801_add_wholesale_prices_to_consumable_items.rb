class AddWholesalePricesToConsumableItems < ActiveRecord::Migration
  def self.up
    rename_column :consumableitems, :wholesale_price, :wholesale_price1
    add_column :consumableitems, :wholesale_price2, :decimal, :precision => 13, :scale => 5, :default => 0
    add_column :consumableitems, :wholesale_price3, :decimal, :precision => 13, :scale => 5, :default => 0
    add_column :consumableitems, :wholesale_price4, :decimal, :precision => 13, :scale => 5, :default => 0
    add_column :consumableitems, :wholesale_price5, :decimal, :precision => 13, :scale => 5, :default => 0
  end

  def self.down
    rename_column :consumableitems, :wholesale_price1, :wholesale_price
    remove_column :consumableitems, :wholesale_price2
    remove_column :consumableitems, :wholesale_price3
    remove_column :consumableitems, :wholesale_price4
    remove_column :consumableitems, :wholesale_price5
  end
end
