class DropCustomerModel < ActiveRecord::Migration
  def self.up
    remove_column :users, :type

    remove_index :users, :name => :index_users_on_type rescue ActiveRecord::StatementInvalid
  end

  def self.down
    add_column :users, :type, :string

    add_index :users, [:type]
  end
end
