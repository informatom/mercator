class AddLegacyIds < ActiveRecord::Migration
  def self.up
    add_column :users, :legacy_id, :integer

    add_column :properties, :legacy_id, :integer

    add_column :countries, :legacy_id, :integer

    add_column :categories, :legacy_id, :integer
  end

  def self.down
    remove_column :users, :legacy_id

    remove_column :properties, :legacy_id

    remove_column :countries, :legacy_id

    remove_column :categories, :legacy_id
  end
end
