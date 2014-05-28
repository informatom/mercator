class RenameContractUseryToCustomer < ActiveRecord::Migration
  def self.up
    remove_index :contracts, :name => :index_contracts_on_user_id rescue ActiveRecord::StatementInvalid
    rename_column :contracts, :user_id, :customer_id

    add_index :contracts, [:customer_id]
  end

  def self.down
    remove_index :contracts, :name => :index_contracts_on_customer_id rescue ActiveRecord::StatementInvalid
    rename_column :contracts, :customer_id, :user_id

    add_index :contracts, [:user_id]
  end
end
