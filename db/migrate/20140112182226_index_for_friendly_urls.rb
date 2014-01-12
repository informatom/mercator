class IndexForFriendlyUrls < ActiveRecord::Migration
  def self.up
    add_index :pages, [:url]
  end

  def self.down
    remove_index :pages, :name => :index_pages_on_url rescue ActiveRecord::StatementInvalid
  end
end
