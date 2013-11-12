class HoboMigration18 < ActiveRecord::Migration
  def self.up
    create_table :lineitems do |t|
      t.string   :product_number
      t.integer  :amount
      t.decimal  :product_price, :scale => 2, :precision => 10
      t.integer  :vat
      t.decimal  :value, :scale => 2, :precision => 10
      t.integer  :position
      t.string   :description_de
      t.string   :description_en
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :lineitems
  end
end
