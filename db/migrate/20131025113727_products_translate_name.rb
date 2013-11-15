class ProductsTranslateName < ActiveRecord::Migration
  def self.up
    rename_column :products, :name, :name_de
    rename_column :products, :dasriction, :description_de
    add_column :products, :description_en, :text
  end

  def self.down
    rename_column :products, :name_de, :name
    rename_column :products, :description_de, :dasriction
    remove_column :products, :description_en
  end
end
