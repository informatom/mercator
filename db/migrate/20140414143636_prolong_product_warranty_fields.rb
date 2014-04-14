class ProlongProductWarrantyFields < ActiveRecord::Migration
  def self.up
    change_column :products, :warranty_de, :text, :limit => nil
    change_column :products, :warranty_en, :text, :limit => nil
  end

  def self.down
    change_column :products, :warranty_de, :string
    change_column :products, :warranty_en, :string
  end
end
