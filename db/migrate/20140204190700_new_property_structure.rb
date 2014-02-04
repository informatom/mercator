class NewPropertyStructure < ActiveRecord::Migration
  def self.up
    remove_column :property_groups, :product_id

    remove_column :properties, :property_group_id

    remove_index :property_groups, :name => :index_property_groups_on_product_id rescue ActiveRecord::StatementInvalid

    remove_index :properties, :name => :index_properties_on_property_group_id rescue ActiveRecord::StatementInvalid
  end

  def self.down
    add_column :property_groups, :product_id, :integer

    add_column :properties, :property_group_id, :integer

    add_index :property_groups, [:product_id]

    add_index :properties, [:property_group_id]
  end
end
