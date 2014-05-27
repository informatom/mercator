class CreateContractitems < ActiveRecord::Migration
  def self.up
    create_table :contractitems do |t|
      t.string   :product_number
      t.string   :description_de
      t.string   :description_en
      t.integer  :amount
      t.string   :unit
      t.decimal  :product_price, :precision => 10, :scale => 2
      t.decimal  :vat, :precision => 10, :scale => 2
      t.decimal  :value, :precision => 10, :scale => 2
      t.decimal  :discount_abs, :scale => 2, :precision => 10, :default => 0
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :user_id
      t.integer  :contract_id
      t.integer  :position
      t.integer  :product_id
    end
    add_index :contractitems, [:user_id]
    add_index :contractitems, [:contract_id]
    add_index :contractitems, [:product_id]

    add_column :contracts, :user_id, :integer
    add_column :contracts, :consultant_id, :integer
    add_column :contracts, :conversation_id, :integer

    add_index :contracts, [:user_id]
    add_index :contracts, [:consultant_id]
    add_index :contracts, [:conversation_id]
  end

  def self.down
    remove_column :contracts, :user_id
    remove_column :contracts, :consultant_id
    remove_column :contracts, :conversation_id

    drop_table :contractitems

    remove_index :contracts, :name => :index_contracts_on_user_id rescue ActiveRecord::StatementInvalid
    remove_index :contracts, :name => :index_contracts_on_consultant_id rescue ActiveRecord::StatementInvalid
    remove_index :contracts, :name => :index_contracts_on_conversation_id rescue ActiveRecord::StatementInvalid
  end
end
