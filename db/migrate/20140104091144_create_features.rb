class CreateFeatures < ActiveRecord::Migration
  def self.up
    create_table :features do |t|
      t.integer  :position
      t.string   :text_de
      t.string   :text_en
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :product_id
    end
    add_index :features, [:product_id]
  end

  def self.down
    drop_table :features
  end
end
