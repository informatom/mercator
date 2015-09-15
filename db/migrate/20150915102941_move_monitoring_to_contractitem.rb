class MoveMonitoringToContractitem < ActiveRecord::Migration
  def self.up
    add_column :contractitems, :monitoring_rate, :decimal, :precision => 13, :scale => 5, :default => 0
    remove_column :contracts, :monitoring_rate
  end

  def self.down
    remove_column :contractitems, :monitoring_rate
    add_column :contracts, :monitoring_rate, :decimal, precision: 13, scale: 5, default: 0.0
  end
end
