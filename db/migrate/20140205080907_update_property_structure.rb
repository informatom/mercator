class UpdatePropertyStructure < ActiveRecord::Migration
  def self.up
    rename_column :values, :value, :amount

    remove_column :properties, :value
    remove_column :properties, :description_de
    remove_column :properties, :description_en
    remove_column :properties, :unit_de
    remove_column :properties, :unit_en
  end

  def self.down
    rename_column :values, :amount, :value

    add_column :properties, :value, :decimal, precision: 10, scale: 2
    add_column :properties, :description_de, :string
    add_column :properties, :description_en, :string
    add_column :properties, :unit_de, :string
    add_column :properties, :unit_en, :string
  end
end
