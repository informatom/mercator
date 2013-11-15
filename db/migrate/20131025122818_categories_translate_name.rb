class CategoriesTranslateName < ActiveRecord::Migration
  def self.up
    rename_column :categories, :name, :name_de
    add_column :categories, :name_en, :string
  end

  def self.down
    rename_column :categories, :name_de, :name
    remove_column :categories, :name_en
  end
end
