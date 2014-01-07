class AddLegacyIdToContentElements < ActiveRecord::Migration
  def self.up
    add_column :content_elements, :legacy_id, :integer
  end

  def self.down
    remove_column :content_elements, :legacy_id
  end
end
