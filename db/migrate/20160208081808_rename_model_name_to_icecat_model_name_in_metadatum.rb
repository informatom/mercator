class RenameModelNameToIcecatModelNameInMetadatum < ActiveRecord::Migration
  def self.up
    rename_column :mercator_icecat_metadata, :model_name, :icecat_model_name
  end

  def self.down
    rename_column :mercator_icecat_metadata, :icecat_model_name, :model_name
  end
end
