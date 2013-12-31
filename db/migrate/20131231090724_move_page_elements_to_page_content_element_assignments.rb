class MovePageElementsToPageContentElementAssignments < ActiveRecord::Migration
  def self.up
    remove_index :page_elements, :name => :index_page_elements_on_page_id rescue ActiveRecord::StatementInvalid
    remove_index :page_elements, :name => :index_page_elements_on_usage_type_and_usage_id rescue ActiveRecord::StatementInvalid
    rename_table :page_elements, :page_content_element_assignments

    rename_column :page_content_element_assignments, :usage_id, :content_element_id
    remove_column :page_content_element_assignments, :usage_type

    add_index :page_content_element_assignments, [:page_id]
    add_index :page_content_element_assignments, [:content_element_id]
  end

  def self.down
    rename_column :page_content_element_assignments, :content_element_id, :usage_id
    add_column :page_elements, :usage_type, :string

    rename_table :page_content_element_assignments, :page_elements

    remove_index :page_elements, :name => :index_page_content_element_assignments_on_page_id rescue ActiveRecord::StatementInvalid
    remove_index :page_elements, :name => :index_page_content_element_assignments_on_content_element_id rescue ActiveRecord::StatementInvalid
    add_index :page_elements, [:page_id]
    add_index :page_elements, [:usage_type, :usage_id]
  end
end
