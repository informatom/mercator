class AddVolumeToContractItem < ActiveRecord::Migration
  def self.up
    add_column :contractitems, :volume, :integer
  end

  def self.down
    remove_column :contractitems, :volume
  end
end
