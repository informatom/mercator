class CreateToners < ActiveRecord::Migration
  def self.up
    create_table :toners do |t|
      t.string   :article_number
      t.string   :description
      t.string   :vendor_number
      t.decimal  :price, :precision => 10, :scale => 2
      t.datetime :created_at
      t.datetime :updated_at
    end

    change_column :prices, :value, :decimal, :limit => nil, :precision => 10, :scale => 2
    change_column :prices, :vat, :decimal, :limit => nil, :precision => 10, :scale => 2
    change_column :prices, :scale_from, :decimal, :limit => nil, :precision => 10, :scale => 2
    change_column :prices, :scale_to, :decimal, :limit => nil, :precision => 10, :scale => 2

    change_column :inventories, :amount, :decimal, :limit => nil, :precision => 10, :scale => 2
    change_column :inventories, :weight, :decimal, :limit => nil, :precision => 10, :scale => 2

    change_column :lineitems, :amount, :decimal, :limit => nil, :precision => 10, :scale => 2
    change_column :lineitems, :vat, :decimal, :limit => nil, :precision => 10, :scale => 2

    change_column :properties, :value, :decimal, :limit => nil, :precision => 10, :scale => 2
  end

  def self.down
    change_column :prices, :value, :decimal, :precision => 10, :scale => 0
    change_column :prices, :vat, :decimal, :precision => 10, :scale => 0
    change_column :prices, :scale_from, :decimal, :precision => 10, :scale => 0
    change_column :prices, :scale_to, :decimal, :precision => 10, :scale => 0

    change_column :inventories, :amount, :decimal, :precision => 10, :scale => 0
    change_column :inventories, :weight, :decimal, :precision => 10, :scale => 0

    change_column :lineitems, :amount, :decimal, :precision => 10, :scale => 0
    change_column :lineitems, :vat, :decimal, :precision => 10, :scale => 0

    change_column :properties, :value, :decimal, :precision => 10, :scale => 0

    drop_table :toners
  end
end
