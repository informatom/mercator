class AddLongDescriptionAndWarrantyToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :long_description_de, :text
    add_column :products, :long_description_en, :text
    add_column :products, :warranty_de, :string
    add_column :products, :warranty_en, :string
  end

  def self.down
    remove_column :products, :long_description_de
    remove_column :products, :long_description_en
    remove_column :products, :warranty_de
    remove_column :products, :warranty_en
  end
end
