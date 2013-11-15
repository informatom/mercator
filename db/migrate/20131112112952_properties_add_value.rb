class PropertiesAddValue < ActiveRecord::Migration
  def self.up
    rename_column :properties, :value_de, :value
    remove_column :properties, :value_en
  end

  def self.down
    rename_column :properties, :value, :value_de
    add_column :properties, :value_en, :decimal
  end
end
