class PropertiesRemoveProductId < ActiveRecord::Migration
  def self.up
    remove_column :properties, :product_id

    remove_index :properties, :name => :index_properties_on_product_id rescue ActiveRecord::StatementInvalid
  end

  def self.down
    add_column :properties, :product_id, :integer

    add_index :properties, [:product_id]
  end
end
