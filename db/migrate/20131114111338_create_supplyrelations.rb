class HoboMigration22 < ActiveRecord::Migration
  def self.up
    create_table :supplyrelations do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :product_id
      t.integer  :supply_id
    end
    add_index :supplyrelations, [:product_id]
    add_index :supplyrelations, [:supply_id]
  end

  def self.down
    drop_table :supplyrelations
  end
end
