class AddValidUntilToOffer < ActiveRecord::Migration
  def self.up
    add_column :offers, :valid_until, :date

    change_column :offeritems, :state, :string, :limit => 255, :default => "in_progress"
  end

  def self.down
    remove_column :offers, :valid_until

    change_column :offeritems, :state, :string, default: "active"
  end
end
