class PropertiesAddProduct < ActiveRecord::Migration
  def self.up
    add_column :properties, :product_id, :integer

    add_index :properties, [:product_id]
  end

  def self.down
    remove_column :properties, :product_id

    remove_index :properties, :name => :index_properties_on_product_id rescue ActiveRecord::StatementInvalid
  end
end
