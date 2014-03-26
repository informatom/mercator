class AddLegacyIdToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :legacy_id, :integer
  end

  def self.down
    remove_column :pages, :legacy_id
  end
end
