class CreateIcecatMetadata < ActiveRecord::Migration
  def self.up
    create_table :mercator_icecat_metadata do |t|
      t.string   :path
      t.datetime :icecat_updated_at
      t.string   :quality
      t.string   :product_number
      t.integer  :category_id
      t.boolean  :on_market
      t.string   :product_name
      t.integer  :product_view_id
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :product_id
    end
    add_index :mercator_icecat_metadata, [:product_id]
  end

  def self.down
    drop_table :mercator_icecat_metadata
  end
end
