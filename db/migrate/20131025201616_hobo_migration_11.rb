class HoboMigration11 < ActiveRecord::Migration
  def self.up
    create_table :content_elements do |t|
      t.string   :name_de
      t.string   :name_en
      t.text     :content_de
      t.text     :content_en
      t.string   :markup
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :content_elements
  end
end
