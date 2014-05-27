class AddTonerToContractitem < ActiveRecord::Migration
  def self.up
    add_column :contractitems, :toner_id, :integer

    add_index :contractitems, [:toner_id]
  end

  def self.down
    remove_column :contractitems, :toner_id

    remove_index :contractitems, :name => :index_contractitems_on_toner_id rescue ActiveRecord::StatementInvalid
  end
end
