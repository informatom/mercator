class CreateProperties < ActiveRecord::Migration
  def self.up
    create_table :properties do |t|
      t.string   :name_de
      t.string   :name_en
      t.decimal   :value_de
      t.decimal   :value_en
      t.integer  :position
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :properties
  end
end
