class AddFieldsToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :url, :string
    add_column :pages, :ancestry, :string
    add_column :pages, :position, :integer
    add_column :pages, :state, :string, :default => "draft"
    add_column :pages, :key_timestamp, :datetime

    add_index :pages, [:ancestry]
    add_index :pages, [:state]
  end

  def self.down
    remove_column :pages, :url
    remove_column :pages, :ancestry
    remove_column :pages, :position
    remove_column :pages, :state
    remove_column :pages, :key_timestamp

    remove_index :pages, :name => :index_pages_on_ancestry rescue ActiveRecord::StatementInvalid
    remove_index :pages, :name => :index_pages_on_state rescue ActiveRecord::StatementInvalid
  end
end
