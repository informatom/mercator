class AddSlugToWebpages < ActiveRecord::Migration
  def self.up
    add_column :webpages, :slug, :string
  end

  def self.down
    remove_column :webpages, :slug
  end
end
