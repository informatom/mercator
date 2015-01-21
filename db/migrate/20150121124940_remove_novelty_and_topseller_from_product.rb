class RemoveNoveltyAndTopsellerFromProduct < ActiveRecord::Migration
  def self.up
    remove_column :products, :novelty
    remove_column :products, :topseller
  end

  def self.down
    add_column :products, :novelty, :boolean
    add_column :products, :topseller, :boolean
  end
end
