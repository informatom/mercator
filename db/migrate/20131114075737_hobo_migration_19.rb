class HoboMigration19 < ActiveRecord::Migration
  def self.up
    create_table :categorizations do |t|
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :categorizations
  end
end
