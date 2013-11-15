class ProductsNameEnglish < ActiveRecord::Migration
  def self.up
    add_column :products, :name_en, :string
  end

  def self.down
    remove_column :products, :name_en
  end
end
