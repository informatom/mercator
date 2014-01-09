class CreateDownloads < ActiveRecord::Migration
  def self.up
    create_table :downloads do |t|
      t.string   :name
      t.datetime :created_at
      t.datetime :updated_at
      t.string   :document_file_name
      t.string   :document_content_type
      t.integer  :document_file_size
      t.datetime :document_updated_at
      t.integer  :conversation_id
    end
    add_index :downloads, [:conversation_id]
  end

  def self.down
    drop_table :downloads
  end
end
