class PageElements < ActiveRecord::Migration
  def self.up
    create_table :page_elements do |t|
      t.string   :usage
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :page_elements
  end
end
