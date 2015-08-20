class RemoveUserFromContractitem < ActiveRecord::Migration
  def self.up
    remove_column :contractitems, :user_id

    remove_index :contractitems, :name => :index_contractitems_on_user_id rescue ActiveRecord::StatementInvalid
  end

  def self.down
    add_column :contractitems, :user_id, :integer

    add_index :contractitems, [:user_id]
  end
end
