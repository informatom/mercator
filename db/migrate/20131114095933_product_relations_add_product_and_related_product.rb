class ProductRelationsAddProductAndRelatedProduct < ActiveRecord::Migration
  def self.up
    add_column :productrelations, :product_id, :integer
    add_column :productrelations, :related_product_id, :integer

    add_index :productrelations, [:product_id]
    add_index :productrelations, [:related_product_id]
  end

  def self.down
    remove_column :productrelations, :product_id
    remove_column :productrelations, :related_product_id

    remove_index :productrelations, :name => :index_productrelations_on_product_id rescue ActiveRecord::StatementInvalid
    remove_index :productrelations, :name => :index_productrelations_on_related_product_id rescue ActiveRecord::StatementInvalid
  end
end
