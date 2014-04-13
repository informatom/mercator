class AddIndexToProdIdInIcecatMetadata < ActiveRecord::Migration
  def self.up
    add_index :mercator_icecat_metadata, [:prod_id]
  end

  def self.down
    remove_index :mercator_icecat_metadata, :name => :index_mercator_icecat_metadata_on_prod_id rescue ActiveRecord::StatementInvalid
  end
end
