class HoboMigration21 < ActiveRecord::Migration
  def self.up
    create_table :productrelations do |t|
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :productrelations
  end
end
