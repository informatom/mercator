class AddVatToShippingCosts < ActiveRecord::Migration
  def self.up
    add_column :shipping_costs, :vat, :decimal, :precision => 10, :scale => 2
  end

  def self.down
    remove_column :shipping_costs, :vat
  end
end
