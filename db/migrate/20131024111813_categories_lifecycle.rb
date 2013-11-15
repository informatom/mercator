class CategoriesLifecycle < ActiveRecord::Migration
  def self.up
    add_column :categories, :state, :string
    add_column :categories, :key_timestamp, :datetime

    add_index :categories, [:state]
  end

  def self.down
    remove_column :categories, :state
    remove_column :categories, :key_timestamp

    remove_index :categories, :name => :index_categories_on_state rescue ActiveRecord::StatementInvalid
  end
end
