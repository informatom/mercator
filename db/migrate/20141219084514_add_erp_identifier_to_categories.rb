class AddErpIdentifierToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :erp_identifier, :string
  end

  def self.down
    remove_column :categories, :erp_identifier
  end
end
