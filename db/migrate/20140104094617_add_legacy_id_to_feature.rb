class AddLegacyIdToFeature < ActiveRecord::Migration
  def self.up
    add_column :features, :legacy_id, :integer
  end

  def self.down
    remove_column :features, :legacy_id
  end
end
