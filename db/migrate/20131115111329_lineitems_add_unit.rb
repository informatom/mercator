class LineitemsAddUnit < ActiveRecord::Migration
  def self.up
    add_column :lineitems, :unit, :string
    change_column :lineitems, :amount, :decimal
  end

  def self.down
    remove_column :lineitems, :unit
    change_column :lineitems, :amount, :integer
  end
end
