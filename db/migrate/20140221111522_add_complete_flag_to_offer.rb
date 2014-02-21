class AddCompleteFlagToOffer < ActiveRecord::Migration
  def self.up
    add_column :offers, :complete, :boolean
  end

  def self.down
    remove_column :offers, :complete
  end
end
