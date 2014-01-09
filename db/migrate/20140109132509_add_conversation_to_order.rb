class AddConversationToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :conversation_id, :integer

    add_index :orders, [:conversation_id]
  end

  def self.down
    remove_column :orders, :conversation_id

    remove_index :orders, :name => :index_orders_on_conversation_id rescue ActiveRecord::StatementInvalid
  end
end
