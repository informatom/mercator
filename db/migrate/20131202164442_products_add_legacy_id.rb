class ProductsAddLegacyId < ActiveRecord::Migration
  def self.up
    add_column :products, :legacy_id, :integer
  end

  def self.down
    remove_column :products, :legacy_id
  end
end
