class PageElementsAddUsageAndPage < ActiveRecord::Migration
  def self.up
    add_column :page_elements, :page_id, :integer
    add_column :page_elements, :usage_id, :integer
    add_column :page_elements, :usage_type, :string

    add_index :page_elements, [:page_id]
    add_index :page_elements, [:usage_type, :usage_id]
  end

  def self.down
    remove_column :page_elements, :page_id
    remove_column :page_elements, :usage_id
    remove_column :page_elements, :usage_type

    remove_index :page_elements, :name => :index_page_elements_on_page_id rescue ActiveRecord::StatementInvalid
    remove_index :page_elements, :name => :index_page_elements_on_usage_type_and_usage_id rescue ActiveRecord::StatementInvalid
  end
end
