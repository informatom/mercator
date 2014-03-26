# This migration comes from mercator_mesonic (originally 20140325093328)
class AddErpContactNrErpAccountNrToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :erp_contact_nr, :string
    add_column :users, :erp_account_nr, :string

    add_index :users, [:erp_account_nr]
  end

  def self.down
    remove_column :users, :erp_contact_nr
    remove_column :users, :erp_account_nr

    remove_index :users, :name => :index_users_on_erp_account_nr rescue ActiveRecord::StatementInvalid
  end
end
