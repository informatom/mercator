class AddDiscountRelToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :discount_rel, :decimal, :scale => 2, :precision => 10, :default => 0
  end

  def self.down
    remove_column :orders, :discount_rel
  end
end
