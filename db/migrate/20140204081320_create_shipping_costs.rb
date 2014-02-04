class CreateShippingCosts < ActiveRecord::Migration
  def self.up
    create_table :shipping_costs do |t|
      t.string   :shipping_method
      t.decimal  :value, :precision => 10, :scale => 2
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :country_id
    end
    add_index :shipping_costs, [:country_id]
  end

  def self.down
    drop_table :shipping_costs
  end
end
