class AddPostCatgeries < ActiveRecord::Migration
  def self.up
    create_table :post_categories do |t|
      t.string   :name_de
      t.string   :name_en
      t.string   :ancestry
      t.datetime :created_at
      t.datetime :updated_at
    end
    add_index :post_categories, [:ancestry]

    add_column :blogposts, :post_category_id, :integer

    add_index :blogposts, [:post_category_id]
  end

  def self.down
    remove_column :blogposts, :post_category_id

    drop_table :post_categories

    remove_index :blogposts, :name => :index_blogposts_on_post_category_id rescue ActiveRecord::StatementInvalid
  end
end
