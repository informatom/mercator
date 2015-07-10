class AddDefaultsInContractiing < ActiveRecord::Migration
  def self.up
    change_column :contractitems, :amount, :integer, :limit => 4, :default => 0
    change_column :contractitems, :product_price, :decimal, :limit => nil, :precision => 13, :scale => 5, :default => 0
    change_column :contractitems, :vat, :decimal, :limit => nil, :precision => 10, :scale => 2, :default => 0
    change_column :contractitems, :value, :decimal, :limit => nil, :precision => 13, :scale => 5, :default => 0
    change_column :contractitems, :volume, :integer, :limit => 4, :default => 0
    change_column :contractitems, :term, :integer, :limit => 4, :default => 0
    change_column :contractitems, :volume_bw, :integer, :limit => 4, :default => 0
    change_column :contractitems, :volume_color, :integer, :limit => 4, :default => 0
    change_column :contractitems, :marge, :decimal, :limit => nil, :precision => 13, :scale => 5, :default => 0
    change_column :contractitems, :monitoring_rate, :decimal, :limit => nil, :precision => 13, :scale => 5, :default => 0

    change_column :contracts, :term, :integer, :limit => 4, :default => 0

    change_column :consumableitems, :amount, :integer, :limit => 4, :default => 0
    change_column :consumableitems, :theyield, :integer, :limit => 4, :default => 0
    change_column :consumableitems, :wholesale_price, :decimal, :limit => nil, :precision => 13, :scale => 5, :default => 0
    change_column :consumableitems, :term, :integer, :limit => 4, :default => 0
    change_column :consumableitems, :consumption1, :integer, :limit => 4, :default => 0
    change_column :consumableitems, :consumption2, :integer, :limit => 4, :default => 0
    change_column :consumableitems, :consumption3, :integer, :limit => 4, :default => 0
    change_column :consumableitems, :consumption4, :integer, :limit => 4, :default => 0
    change_column :consumableitems, :consumption5, :integer, :limit => 4, :default => 0
    change_column :consumableitems, :consumption6, :integer, :limit => 4, :default => 0
    change_column :consumableitems, :balance6, :decimal, :limit => nil, :precision => 13, :scale => 5, :default => 0
  end

  def self.down
    change_column :contractitems, :amount, :integer
    change_column :contractitems, :product_price, :decimal, precision: 13, scale: 5
    change_column :contractitems, :vat, :decimal, precision: 10, scale: 2
    change_column :contractitems, :value, :decimal, precision: 13, scale: 5
    change_column :contractitems, :volume, :integer
    change_column :contractitems, :term, :integer
    change_column :contractitems, :volume_bw, :integer
    change_column :contractitems, :volume_color, :integer
    change_column :contractitems, :marge, :decimal, precision: 13, scale: 5
    change_column :contractitems, :monitoring_rate, :decimal, precision: 13, scale: 5

    change_column :contracts, :term, :integer

    change_column :consumableitems, :amount, :integer
    change_column :consumableitems, :theyield, :integer
    change_column :consumableitems, :wholesale_price, :decimal, precision: 13, scale: 5
    change_column :consumableitems, :term, :integer
    change_column :consumableitems, :consumption1, :integer
    change_column :consumableitems, :consumption2, :integer
    change_column :consumableitems, :consumption3, :integer
    change_column :consumableitems, :consumption4, :integer
    change_column :consumableitems, :consumption5, :integer
    change_column :consumableitems, :consumption6, :integer
    change_column :consumableitems, :balance6, :decimal, precision: 13, scale: 5
  end
end
