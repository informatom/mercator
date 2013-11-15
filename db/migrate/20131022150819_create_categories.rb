class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string   :name
      t.string   :ancestry
      t.integer  :position
      t.boolean  :active
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :categories
  end
end
