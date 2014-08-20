class AddMenuToWebpages < ActiveRecord::Migration
  def self.up
    add_column :webpages, :menu, :boolean

    remove_index :webpages, :name => :index_webpages_on_url rescue ActiveRecord::StatementInvalid
  end

  def self.down
    remove_column :webpages, :menu

    add_index :webpages, [:url]
  end
end
