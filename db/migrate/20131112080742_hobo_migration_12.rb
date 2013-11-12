class HoboMigration12 < ActiveRecord::Migration
  def self.up
    create_table :constants do |t|
      t.string   :key
      t.string   :value
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :constants
  end
end
