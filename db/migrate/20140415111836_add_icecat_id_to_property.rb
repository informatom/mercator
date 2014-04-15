class AddIcecatIdToProperty < ActiveRecord::Migration
  def self.up
    add_column :properties, :icecat_id, :integer
  end

  def self.down
    remove_column :properties, :icecat_id
  end
end
