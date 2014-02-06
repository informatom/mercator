class RenameProductNameToTitle < ActiveRecord::Migration
  def self.up
    rename_column :products, :name_de, :title_de
    rename_column :products, :name_en, :title_en
  end

  def self.down
    rename_column :products, :title_de, :name_de
    rename_column :products, :title_en, :name_en
  end
end
