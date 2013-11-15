class PropertiesAddDescriptionAndUnit < ActiveRecord::Migration
  def self.up
    add_column :properties, :description_de, :string
    add_column :properties, :description_en, :string
    add_column :properties, :unit_de, :string
    add_column :properties, :unit_en, :string
  end

  def self.down
    remove_column :properties, :description_de
    remove_column :properties, :description_en
    remove_column :properties, :unit_de
    remove_column :properties, :unit_en
  end
end
