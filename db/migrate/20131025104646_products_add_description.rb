class ProductsAddDescription < ActiveRecord::Migration
  def self.up
    add_column :products, :dasriction, :text
  end

  def self.down
    remove_column :products, :dasriction
  end
end
