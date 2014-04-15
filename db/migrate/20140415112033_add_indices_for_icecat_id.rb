class AddIndicesForIcecatId < ActiveRecord::Migration
  def self.up
    add_index :property_groups, [:icecat_id]

    add_index :properties, [:icecat_id]
  end

  def self.down
    remove_index :property_groups, :name => :index_property_groups_on_icecat_id rescue ActiveRecord::StatementInvalid

    remove_index :properties, :name => :index_properties_on_icecat_id rescue ActiveRecord::StatementInvalid
  end
end
