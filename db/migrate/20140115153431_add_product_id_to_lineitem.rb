class AddProductIdToLineitem < ActiveRecord::Migration
  def self.up
    add_column :lineitems, :product_id, :integer
  end

  def self.down
    remove_column :lineitems, :product_id
  end
end
