class AddDeliveryTimeToLineitem < ActiveRecord::Migration
  def self.up
    add_column :lineitems, :delivery_time, :string
  end

  def self.down
    remove_column :lineitems, :delivery_time
  end
end
