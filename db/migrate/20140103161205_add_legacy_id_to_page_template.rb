class AddLegacyIdToPageTemplate < ActiveRecord::Migration
  def self.up
    add_column :page_templates, :legacy_id, :integer
  end

  def self.down
    remove_column :page_templates, :legacy_id
  end
end
