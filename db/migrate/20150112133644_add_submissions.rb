class AddSubmissions < ActiveRecord::Migration
  def self.up
    create_table :submissions do |t|
      t.string   :name
      t.string   :email
      t.string   :phone
      t.text     :message
      t.string   :answer
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :submissions
  end
end
