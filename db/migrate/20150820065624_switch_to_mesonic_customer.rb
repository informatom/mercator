class SwitchToMesonicCustomer < ActiveRecord::Migration
  def self.up
    add_column :contracts, :customer_account, :text
    add_column :contracts, :customer, :text
    remove_column :contracts, :customer_id

    remove_index :contracts, :name => :index_contracts_on_customer_id rescue ActiveRecord::StatementInvalid
  end

  def self.down
    remove_column :contracts, :customer_account
    remove_column :contracts, :customer
    add_column :contracts, :customer_id, :integer

    add_index :contracts, [:customer_id]
  end
end
