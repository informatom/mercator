class HoboMigration20 < ActiveRecord::Migration
  def self.up
    add_column :categorizations, :category_id, :integer
    add_column :categorizations, :product_id, :integer

    add_index :categorizations, [:category_id]
    add_index :categorizations, [:product_id]
  end

  def self.down
    remove_column :categorizations, :category_id
    remove_column :categorizations, :product_id

    remove_index :categorizations, :name => :index_categorizations_on_category_id rescue ActiveRecord::StatementInvalid
    remove_index :categorizations, :name => :index_categorizations_on_product_id rescue ActiveRecord::StatementInvalid
  end
end
