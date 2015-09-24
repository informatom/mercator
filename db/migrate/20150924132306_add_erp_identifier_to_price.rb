class AddErpIdentifierToPrice < ActiveRecord::Migration
  def self.up
    add_column :prices, :erp_identifier, :integer
    add_index :users, [:erp_contact_nr]
  end

  def self.down
    remove_column :prices, :erp_identifier
    remove_index :users, :name => :index_users_on_erp_contact_nr rescue ActiveRecord::StatementInvalid
  end
end
