class CreateInventories < ActiveRecord::Migration
  def self.up
    create_table :inventories do |t|
      t.string   :name_de
      t.string   :name_en
      t.string   :number
      t.decimal  :amount
      t.string   :unit
      t.string   :comment_de
      t.string   :comment_en
      t.decimal  :weight
      t.string   :charge
      t.string   :storage
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :product_id
    end
    add_index :inventories, [:product_id]
  end

  def self.down
    drop_table :inventories
  end
end
