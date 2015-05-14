class RemoveUniquenessFromPropertyIcecatId < ActiveRecord::Migration
  def self.up
    remove_index :properties, :name => :index_properties_on_icecat_id rescue ActiveRecord::StatementInvalid
    add_index :properties, [:icecat_id]
  end

  def self.down
    remove_index :properties, :name => :index_properties_on_icecat_id rescue ActiveRecord::StatementInvalid
    add_index :properties, [:icecat_id], :unique => true
  end
end
