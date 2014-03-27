class AddCOToAddress < ActiveRecord::Migration
  def self.up
    add_column :addresses, :c_o, :string
  end

  def self.down
    remove_column :addresses, :c_o
  end
end
