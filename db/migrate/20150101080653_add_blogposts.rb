class AddBlogposts < ActiveRecord::Migration
  def self.up
    create_table :blogposts do |t|
      t.string   :title_de
      t.string   :title_en
      t.date     :publishing_date
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :content_element_id
    end
    add_index :blogposts, [:content_element_id]
  end

  def self.down
    drop_table :blogposts
  end
end
