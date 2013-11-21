class LineItemAddUserId < ActiveRecord::Migration
  def self.up
    add_column :lineitems, :user_id, :integer

    add_index :lineitems, [:user_id]
  end

  def self.down
    remove_column :lineitems, :user_id

    remove_index :lineitems, :name => :index_lineitems_on_user_id rescue ActiveRecord::StatementInvalid
  end
end
