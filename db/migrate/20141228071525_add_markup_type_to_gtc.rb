class AddMarkupTypeToGtc < ActiveRecord::Migration
  def self.up
    add_column :gtcs, :markup, :string
  end

  def self.down
    remove_column :gtcs, :markup
  end
end
