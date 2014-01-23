class FixGtcTitle < ActiveRecord::Migration
  def self.up
    rename_column :gtcs, :titel_de, :title_de
    rename_column :gtcs, :titel_en, :title_en
  end

  def self.down
    rename_column :gtcs, :title_de, :titel_de
    rename_column :gtcs, :title_en, :titel_en
  end
end
