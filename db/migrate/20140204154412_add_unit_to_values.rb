class AddUnitToValues < ActiveRecord::Migration
  def self.up
    add_column :values, :unit_de, :string
    add_column :values, :unit_en, :string
  end

  def self.down
    remove_column :values, :unit_de
    remove_column :values, :unit_en
  end
end
