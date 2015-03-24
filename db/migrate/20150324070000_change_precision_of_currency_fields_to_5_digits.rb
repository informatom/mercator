class ChangePrecisionOfCurrencyFieldsTo5Digits < ActiveRecord::Migration
  def self.up
    change_column :lineitems, :product_price, :decimal, :limit => nil, :precision => 13, :scale => 5
    change_column :lineitems, :value, :decimal, :limit => nil, :precision => 13, :scale => 5
    change_column :lineitems, :discount_abs, :decimal, :limit => nil, :precision => 13, :scale => 5, :default => 0

    change_column :orders, :discount_rel, :decimal, :limit => nil, :precision => 13, :scale => 5, :default => 0

    change_column :offers, :discount_rel, :decimal, :limit => nil, :precision => 13, :scale => 5, :default => 0

    change_column :offeritems, :product_price, :decimal, :limit => nil, :precision => 13, :scale => 5
    change_column :offeritems, :value, :decimal, :limit => nil, :precision => 13, :scale => 5
    change_column :offeritems, :discount_abs, :decimal, :limit => nil, :precision => 13, :scale => 5, :default => 0

    change_column :toners, :price, :decimal, :limit => nil, :precision => 13, :scale => 5

    change_column :consumableitems, :wholesale_price, :decimal, :limit => nil, :precision => 13, :scale => 5
    change_column :consumableitems, :balance6, :decimal, :limit => nil, :precision => 13, :scale => 5

    change_column :contractitems, :product_price, :decimal, :limit => nil, :precision => 13, :scale => 5
    change_column :contractitems, :value, :decimal, :limit => nil, :precision => 13, :scale => 5
    change_column :contractitems, :marge, :decimal, :limit => nil, :precision => 13, :scale => 5
    change_column :contractitems, :monitoring_rate, :decimal, :limit => nil, :precision => 13, :scale => 5

    change_column :shipping_costs, :value, :decimal, :limit => nil, :precision => 13, :scale => 5

    change_column :prices, :value, :decimal, :limit => nil, :precision => 13, :scale => 5

  end

  def self.down
    change_column :lineitems, :product_price, :decimal, precision: 10, scale: 2
    change_column :lineitems, :value, :decimal, precision: 10, scale: 2
    change_column :lineitems, :discount_abs, :decimal, precision: 10, scale: 2, default: 0.0

    change_column :orders, :discount_rel, :decimal, precision: 10, scale: 2, default: 0.0

    change_column :offers, :discount_rel, :decimal, precision: 10, scale: 2, default: 0.0

    change_column :offeritems, :product_price, :decimal, precision: 10, scale: 2
    change_column :offeritems, :value, :decimal, precision: 10, scale: 2
    change_column :offeritems, :discount_abs, :decimal, precision: 10, scale: 2, default: 0.0

    change_column :toners, :price, :decimal, precision: 10, scale: 2

    change_column :consumableitems, :wholesale_price, :decimal, precision: 10, scale: 2
    change_column :consumableitems, :balance6, :decimal, precision: 10, scale: 2

    change_column :contractitems, :product_price, :decimal, precision: 10, scale: 2
    change_column :contractitems, :value, :decimal, precision: 10, scale: 2
    change_column :contractitems, :marge, :decimal, precision: 10, scale: 2
    change_column :contractitems, :monitoring_rate, :decimal, precision: 10, scale: 2

    change_column :shipping_costs, :value, :decimal, precision: 10, scale: 2

    change_column :prices, :value, :decimal, precision: 10, scale: 2

  end
end
