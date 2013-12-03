class CategoriesAddDescriptions < ActiveRecord::Migration
  def self.up
    add_column :categories, :description_de, :text
    add_column :categories, :description_en, :text
    add_column :categories, :long_description_de, :text
    add_column :categories, :long_description_en, :text
  end

  def self.down
    remove_column :categories, :description_de
    remove_column :categories, :description_en
    remove_column :categories, :long_description_de
    remove_column :categories, :long_description_en
  end
end
