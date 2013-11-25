class CategorizationsAddPosition < ActiveRecord::Migration
  def self.up
    add_column :categorizations, :position, :integer
  end

  def self.down
    remove_column :categorizations, :position
  end
end
