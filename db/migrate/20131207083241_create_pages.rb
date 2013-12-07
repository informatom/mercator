class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string   :title_de
      t.string   :title_en
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :pages
  end
end
