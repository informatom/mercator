class RemoveProductPriceAndValueFromContractitem < ActiveRecord::Migration
  def self.up
    remove_column :contractitems, :product_price
    remove_column :contractitems, :value
  end

  def self.down
    add_column :contractitems, :product_price, :decimal, precision: 13, scale: 5, default: 0.0
    add_column :contractitems, :value, :decimal, precision: 13, scale: 5, default: 0.0
  end
end