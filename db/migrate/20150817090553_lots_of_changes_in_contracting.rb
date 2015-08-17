class LotsOfChangesInContracting < ActiveRecord::Migration
  def self.up
    add_column :consumableitems, :product_title, :string
    remove_column :consumableitems, :description_de
    remove_column :consumableitems, :description_en
    remove_column :consumableitems, :balance6

    add_column :contractitems, :product_title, :string
    remove_column :contractitems, :description_de
    remove_column :contractitems, :description_en
    remove_column :contractitems, :unit
    remove_column :contractitems, :discount_abs
    remove_column :contractitems, :toner_id
    remove_column :contractitems, :monitoring_rate

    add_column :contracts, :contractnumber, :string
    add_column :contracts, :monitoring_rate, :decimal, :precision => 13, :scale => 5, :default => 0
    remove_column :contracts, :consultant_id
    remove_column :contracts, :conversation_id

    remove_index :contractitems, :name => :index_contractitems_on_toner_id rescue ActiveRecord::StatementInvalid
    remove_index :contracts, :name => :index_contracts_on_consultant_id rescue ActiveRecord::StatementInvalid
    remove_index :contracts, :name => :index_contracts_on_conversation_id rescue ActiveRecord::StatementInvalid
  end

  def self.down
    remove_column :consumableitems, :product_title
    add_column :consumableitems, :description_de, :string
    add_column :consumableitems, :description_en, :string
    add_column :consumableitems, :balance6, :decimal, precision: 13, scale: 5, default: 0.0

    remove_column :contractitems, :product_title
    add_column :contractitems, :description_de, :string
    add_column :contractitems, :description_en, :string
    add_column :contractitems, :unit, :string
    add_column :contractitems, :discount_abs, :decimal, precision: 10, scale: 2, default: 0.0
    add_column :contractitems, :toner_id, :integer
    add_column :contractitems, :monitoring_rate, :decimal, precision: 13, scale: 5, default: 0.0

    remove_column :contracts, :contractnumber
    remove_column :contracts, :monitoring_rate
    add_column :contracts, :consultant_id, :integer
    add_column :contracts, :conversation_id, :integer

    add_index :contractitems, [:toner_id]
    add_index :contracts, [:consultant_id]
    add_index :contracts, [:conversation_id]
  end
end
