class CreateAddress < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.integer  :user_id
      t.string   :name
      t.string   :detail
      t.string   :street
      t.string   :postalcode
      t.string   :city
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :addresses
  end
end
