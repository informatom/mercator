class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.string   :billing_method
      t.string   :billing_name
      t.string   :billing_detail
      t.string   :billing_street
      t.string   :billing_postalcode
      t.string   :billing_city
      t.string   :billing_country
      t.string   :shipping_method
      t.string   :shipping_name
      t.string   :shipping_detail
      t.string   :shipping_street
      t.string   :shipping_postalcode
      t.string   :shipping_city
      t.string   :shipping_country
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :user_id
    end
    add_index :orders, [:user_id]

    add_column :lineitems, :order_id, :integer

    add_index :lineitems, [:order_id]
  end

  def self.down
    remove_column :lineitems, :order_id

    drop_table :orders

    remove_index :lineitems, :name => :index_lineitems_on_order_id rescue ActiveRecord::StatementInvalid
  end
end
