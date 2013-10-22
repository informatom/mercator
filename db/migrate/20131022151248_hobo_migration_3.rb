class HoboMigration3 < ActiveRecord::Migration
  def self.up
    add_index :categories, [:ancestry]
  end

  def self.down
    remove_index :categories, :name => :index_categories_on_ancestry rescue ActiveRecord::StatementInvalid
  end
end
