class AddDiscountAbsToLineitem < ActiveRecord::Migration
  def self.up
    add_column :lineitems, :discount_abs, :decimal, :scale => 2, :precision => 10, :default => 0
  end

  def self.down
    remove_column :lineitems, :discount_abs
  end
end
