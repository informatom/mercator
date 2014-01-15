class ProductIdIndexForLineitem < ActiveRecord::Migration
  def self.up
    add_index :lineitems, [:product_id]
  end

  def self.down
    remove_index :lineitems, :name => :index_lineitems_on_product_id rescue ActiveRecord::StatementInvalid
  end
end
