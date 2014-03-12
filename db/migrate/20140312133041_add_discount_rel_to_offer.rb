class AddDiscountRelToOffer < ActiveRecord::Migration
  def self.up
    add_column :offers, :discount_rel, :decimal, :scale => 2, :precision => 10
  end

  def self.down
    remove_column :offers, :discount_rel
  end
end
