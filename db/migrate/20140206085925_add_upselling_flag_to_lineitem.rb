class AddUpsellingFlagToLineitem < ActiveRecord::Migration
  def self.up
    add_column :lineitems, :upselling, :boolean
  end

  def self.down
    remove_column :lineitems, :upselling
  end
end
