class CreateFolder < ActiveRecord::Migration
  def self.up
    create_table :folders do |t|
      t.string   :name
      t.string   :ancestry
      t.integer  :position
      t.datetime :created_at
      t.datetime :updated_at
    end
    add_index :folders, [:ancestry]

    add_column :content_elements, :folder_id, :integer

    add_index :content_elements, [:folder_id]
  end

  def self.down
    remove_column :content_elements, :folder_id

    drop_table :folders

    remove_index :content_elements, :name => :index_content_elements_on_folder_id rescue ActiveRecord::StatementInvalid
  end
end
