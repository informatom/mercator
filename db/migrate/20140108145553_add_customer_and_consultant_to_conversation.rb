class AddCustomerAndConsultantToConversation < ActiveRecord::Migration
  def self.up
    add_column :conversations, :customer_id, :integer
    add_column :conversations, :consultant_id, :integer

    add_index :conversations, [:customer_id]
    add_index :conversations, [:consultant_id]
  end

  def self.down
    remove_column :conversations, :customer_id
    remove_column :conversations, :consultant_id

    remove_index :conversations, :name => :index_conversations_on_customer_id rescue ActiveRecord::StatementInvalid
    remove_index :conversations, :name => :index_conversations_on_consultant_id rescue ActiveRecord::StatementInvalid
  end
end
