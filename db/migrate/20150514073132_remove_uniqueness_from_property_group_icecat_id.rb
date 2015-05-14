class RemoveUniquenessFromPropertyGroupIcecatId < ActiveRecord::Migration
  def self.up
    remove_index :property_groups, :name => :index_property_groups_on_icecat_id rescue ActiveRecord::StatementInvalid
    add_index :property_groups, [:icecat_id]
  end

  def self.down
    remove_index :property_groups, :name => :index_property_groups_on_icecat_id rescue ActiveRecord::StatementInvalid
    add_index :property_groups, [:icecat_id], :unique => true
  end
end
