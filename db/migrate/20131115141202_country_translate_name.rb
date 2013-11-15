class CountryTranslateName < ActiveRecord::Migration
  def self.up
    rename_column :countries, :name, :name_de
    add_column :countries, :name_en, :string
  end

  def self.down
    rename_column :countries, :name_de, :name
    remove_column :countries, :name_en
  end
end
