class CreateValues < ActiveRecord::Migration
  def self.up
    create_table :values do |t|
      t.string   :title_de
      t.string   :title_en
      t.decimal  :value, :precision => 10, :scale => 2
      t.boolean  :flag
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :property_group_id
      t.integer  :property_id
      t.integer  :product_id
      t.string   :state, :default => "textual"
      t.datetime :key_timestamp
    end
    add_index :values, [:property_group_id]
    add_index :values, [:property_id]
    add_index :values, [:product_id]
    add_index :values, [:state]

    add_column :properties, :datatype, :string
  end

  def self.down
    remove_column :properties, :datatype

    drop_table :values
  end
end
