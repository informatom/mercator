class SetDefaultDicountRelInOffer < ActiveRecord::Migration
  def self.up
    change_column :offers, :discount_rel, :decimal, :limit => nil, :precision => 10, :scale => 2, :default => 0
  end

  def self.down
    change_column :offers, :discount_rel, :decimal, precision: 10, scale: 2
  end
end
