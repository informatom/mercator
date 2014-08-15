class AddDrymlToPageTemplates < ActiveRecord::Migration
  def self.up
    add_column :page_templates, :dryml, :boolean
  end

  def self.down
    remove_column :page_templates, :dryml
  end
end
