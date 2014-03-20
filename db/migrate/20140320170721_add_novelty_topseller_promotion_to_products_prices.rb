class AddNoveltyTopsellerPromotionToProductsPrices < ActiveRecord::Migration
  def self.up
    add_column :products, :novelty, :boolean
    add_column :products, :topseller, :boolean

    add_column :prices, :promotion, :boolean
  end

  def self.down
    remove_column :products, :novelty
    remove_column :products, :topseller

    remove_column :prices, :promotion
  end
end
