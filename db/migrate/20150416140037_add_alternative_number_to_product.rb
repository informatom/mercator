class AddAlternativeNumberToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :alternative_number, :string
  end

  def self.down
    remove_column :products, :alternative_number
  end
end
