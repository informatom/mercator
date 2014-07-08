class ContractingMerge < ActiveRecord::Migration
  def self.up
    create_table :consumableitems do |t|
      t.integer  :position
      t.string   :product_number
      t.string   :product_line
      t.string   :description_de
      t.string   :description_en
      t.integer  :amount
      t.integer  :theyield
      t.decimal  :wholesale_price, :precision => 10, :scale => 2
      t.integer  :term
      t.integer  :consumption1
      t.integer  :consumption2
      t.integer  :consumption3
      t.integer  :consumption4
      t.integer  :consumption5
      t.integer  :consumption6
      t.decimal  :balance6, :precision => 10, :scale => 2
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :contractitem_id
    end
    add_index :consumableitems, [:contractitem_id]

    add_column :contractitems, :term, :integer
    add_column :contractitems, :startdate, :date
    add_column :contractitems, :volume_bw, :integer
    add_column :contractitems, :volume_color, :integer
    add_column :contractitems, :marge, :decimal, :precision => 10, :scale => 2
    add_column :contractitems, :monitoring_rate, :decimal, :precision => 10, :scale => 2

    add_column :contracts, :term, :integer
  end

  def self.down
    remove_column :contractitems, :term
    remove_column :contractitems, :startdate
    remove_column :contractitems, :volume_bw
    remove_column :contractitems, :volume_color
    remove_column :contractitems, :marge
    remove_column :contractitems, :monitoring_rate

    remove_column :contracts, :term

    drop_table :consumableitems
  end
end
