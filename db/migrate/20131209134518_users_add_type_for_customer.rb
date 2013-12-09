class UsersAddTypeForCustomer < ActiveRecord::Migration
  def self.up
    add_column :users, :type, :string

    add_index :users, [:type]
  end

  def self.down
    remove_column :users, :type

    remove_index :users, :name => :index_users_on_type rescue ActiveRecord::StatementInvalid
  end
end
