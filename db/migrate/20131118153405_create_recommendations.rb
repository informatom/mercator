class CreateRecommendations < ActiveRecord::Migration
  def self.up
    create_table :recommendations do |t|
      t.string   :reason_de
      t.string   :reason_en
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :product_id
      t.integer  :recommended_product_id
    end
    add_index :recommendations, [:product_id]
    add_index :recommendations, [:recommended_product_id]
  end

  def self.down
    drop_table :recommendations
  end
end
