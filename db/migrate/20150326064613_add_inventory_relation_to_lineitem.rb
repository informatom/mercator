class AddInventoryRelationToLineitem < ActiveRecord::Migration
  def self.up
    add_column :lineitems, :inventory_id, :integer

    add_index :lineitems, [:inventory_id]
  end

  def self.down
    remove_column :lineitems, :inventory_id

    remove_index :lineitems, :name => :index_lineitems_on_inventory_id rescue ActiveRecord::StatementInvalid
  end
end
