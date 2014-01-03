class PagesBelongToPageTemplates < ActiveRecord::Migration
  def self.up
    add_column :pages, :page_template_id, :integer

    add_index :pages, [:page_template_id]
  end

  def self.down
    remove_column :pages, :page_template_id

    remove_index :pages, :name => :index_pages_on_page_template_id rescue ActiveRecord::StatementInvalid
  end
end
