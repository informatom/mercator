class ChangeIcecatMetadata < ActiveRecord::Migration
  def self.up
    rename_column :mercator_icecat_metadata, :category_id, :cat_id
    rename_column :mercator_icecat_metadata, :product_name, :model_name
    rename_column :mercator_icecat_metadata, :product_view_id, :product_view
    add_column :mercator_icecat_metadata, :supplier_id, :string
    add_column :mercator_icecat_metadata, :icecat_product_id, :string
    add_column :mercator_icecat_metadata, :prod_id, :string
    change_column :mercator_icecat_metadata, :on_market, :string, :limit => 255
    change_column :mercator_icecat_metadata, :cat_id, :string, :limit => 255
    change_column :mercator_icecat_metadata, :product_view, :string, :limit => 255
  end

  def self.down
    rename_column :mercator_icecat_metadata, :cat_id, :category_id
    rename_column :mercator_icecat_metadata, :model_name, :product_name
    rename_column :mercator_icecat_metadata, :product_view, :product_view_id
    remove_column :mercator_icecat_metadata, :supplier_id
    remove_column :mercator_icecat_metadata, :icecat_product_id
    remove_column :mercator_icecat_metadata, :prod_id
    change_column :mercator_icecat_metadata, :on_market, :boolean
    change_column :mercator_icecat_metadata, :category_id, :integer
    change_column :mercator_icecat_metadata, :product_view_id, :integer
  end
end
