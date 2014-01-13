class RenamePageToWebpage < ActiveRecord::Migration
  def self.up
    remove_index :pages, :name => :index_pages_on_ancestry rescue ActiveRecord::StatementInvalid
    remove_index :pages, :name => :index_pages_on_state rescue ActiveRecord::StatementInvalid
    remove_index :pages, :name => :index_pages_on_page_template_id rescue ActiveRecord::StatementInvalid
    remove_index :pages, :name => :index_pages_on_url rescue ActiveRecord::StatementInvalid
    remove_index :page_content_element_assignments, :name => :index_page_content_element_assignments_on_page_id rescue ActiveRecord::StatementInvalid

    rename_table :pages, :webpages
    rename_column :page_content_element_assignments, :page_id, :webpage_id

    add_index :webpages, [:url]
    add_index :webpages, [:ancestry]
    add_index :webpages, [:page_template_id]
    add_index :webpages, [:state]

    add_index :page_content_element_assignments, [:webpage_id]
  end

  def self.down
    remove_index :webpages, :name => :index_webpages_on_url rescue ActiveRecord::StatementInvalid
    remove_index :webpages, :name => :index_webpages_on_ancestry rescue ActiveRecord::StatementInvalid
    remove_index :webpages, :name => :index_webpages_on_page_template_id rescue ActiveRecord::StatementInvalid
    remove_index :webpages, :name => :index_webpages_on_state rescue ActiveRecord::StatementInvalid
    remove_index :page_content_element_assignments, :name => :index_page_content_element_assignments_on_webpage_id rescue ActiveRecord::StatementInvalid

    rename_column :page_content_element_assignments, :webpage_id, :page_id
    rename_table :webpages, :pages

    add_index :pages, [:ancestry]
    add_index :pages, [:state]
    add_index :pages, [:page_template_id]
    add_index :pages, [:url]

    add_index :page_content_element_assignments, [:page_id]
  end
end
