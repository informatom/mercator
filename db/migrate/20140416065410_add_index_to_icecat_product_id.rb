class AddIndexToIcecatProductId < ActiveRecord::Migration
  def self.up
    remove_index :properties, :name => :index_properties_on_icecat_id rescue ActiveRecord::StatementInvalid
    add_index :properties, [:icecat_id], :unique => true

    add_index :mercator_icecat_metadata, [:icecat_product_id]
  end

  def self.down
    remove_index :properties, :name => :index_properties_on_icecat_id rescue ActiveRecord::StatementInvalid
    add_index :properties, [:icecat_id]

    remove_index :mercator_icecat_metadata, :name => :index_mercator_icecat_metadata_on_icecat_product_id rescue ActiveRecord::StatementInvalid
  end
end
