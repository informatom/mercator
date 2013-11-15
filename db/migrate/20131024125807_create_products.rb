class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string   :name
      t.string   :number
      t.datetime :created_at
      t.datetime :updated_at
      t.string   :state, :default => "new"
      t.datetime :key_timestamp
    end
    add_index :products, [:state]
  end

  def self.down
    drop_table :products
  end
end
