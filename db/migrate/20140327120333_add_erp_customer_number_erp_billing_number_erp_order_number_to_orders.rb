class AddErpCustomerNumberErpBillingNumberErpOrderNumberToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :erp_customer_number, :string
    add_column :orders, :erp_billing_number, :string
    add_column :orders, :erp_order_number, :string
  end

  def self.down
    remove_column :orders, :erp_customer_number
    remove_column :orders, :erp_billing_number
    remove_column :orders, :erp_order_number
  end
end
