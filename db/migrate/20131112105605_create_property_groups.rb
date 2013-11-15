class HoboMigration15 < ActiveRecord::Migration
  def self.up
    create_table :property_groups do |t|
      t.string   :name_de
      t.string   :name_en
      t.integer  :position
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :product_id
    end
    add_index :property_groups, [:product_id]

    add_column :properties, :property_group_id, :integer

    add_index :properties, [:property_group_id]
  end

  def self.down
    remove_column :properties, :property_group_id

    drop_table :property_groups

    remove_index :properties, :name => :index_properties_on_property_group_id rescue ActiveRecord::StatementInvalid
  end
end
