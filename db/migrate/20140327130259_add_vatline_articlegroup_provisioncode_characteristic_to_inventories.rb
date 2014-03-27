class AddVatlineArticlegroupProvisioncodeCharacteristicToInventories < ActiveRecord::Migration
  def self.up
    add_column :inventories, :erp_vatline, :integer
    add_column :inventories, :erp_article_group, :integer
    add_column :inventories, :erp_provision_code, :integer
    add_column :inventories, :erp_characteristic_flag, :integer
  end

  def self.down
    remove_column :inventories, :erp_vatline
    remove_column :inventories, :erp_article_group
    remove_column :inventories, :erp_provision_code
    remove_column :inventories, :erp_characteristic_flag
  end
end
