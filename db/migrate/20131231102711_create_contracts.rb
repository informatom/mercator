class CreateContracts < ActiveRecord::Migration
  def self.up
    create_table :contracts do |t|
      t.integer  :runtime
      t.date     :startdate
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :contracts
  end
end
