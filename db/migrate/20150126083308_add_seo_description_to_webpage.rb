class AddSeoDescriptionToWebpage < ActiveRecord::Migration
  def self.up
    add_column :webpages, :seo_description, :string
  end

  def self.down
    remove_column :webpages, :seo_description
  end
end
