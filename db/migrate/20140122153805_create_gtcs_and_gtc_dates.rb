class CreateGtcsAndGtcDates < ActiveRecord::Migration
  def self.up
    create_table :gtcs do |t|
      t.string   :titel_de
      t.string   :titel_en
      t.text     :content_de
      t.text     :content_en
      t.date     :version_of
      t.datetime :created_at
      t.datetime :updated_at
    end

    add_column :users, :gtc_confirmed_at, :datetime
    add_column :users, :gtc_version_of, :date

    add_column :orders, :gtc_confirmed_at, :datetime
    add_column :orders, :gtc_version_of, :date
  end

  def self.down
    remove_column :users, :gtc_confirmed_at
    remove_column :users, :gtc_version_of

    remove_column :orders, :gtc_confirmed_at
    remove_column :orders, :gtc_version_of

    drop_table :gtcs
  end
end
