class RemoveRuntimeFromContract < ActiveRecord::Migration
  def self.up
    remove_column :contracts, :runtime
  end

  def self.down
    add_column :contracts, :runtime, :integer
  end
end
