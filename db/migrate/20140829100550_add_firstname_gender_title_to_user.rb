class AddFirstnameGenderTitleToUser < ActiveRecord::Migration
  def self.up
    rename_column :users, :name, :surname
    add_column :users, :gender, :string
    add_column :users, :title, :string
    add_column :users, :first_name, :string
  end

  def self.down
    rename_column :users, :surname, :name
    remove_column :users, :gender
    remove_column :users, :title
    remove_column :users, :first_name
  end
end
