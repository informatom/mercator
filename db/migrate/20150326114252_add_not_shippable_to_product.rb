class AddNotShippableToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :not_shippable, :boolean
  end

  def self.down
    remove_column :products, :not_shippable
  end
end
