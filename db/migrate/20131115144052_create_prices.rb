class CreatePrices < ActiveRecord::Migration
  def self.up
    create_table :prices do |t|
      t.decimal  :value
      t.decimal  :vat
      t.date     :valid_from
      t.date     :valid_to
      t.decimal  :scale_from
      t.decimal  :scale_to
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :inventory_id
    end
    add_index :prices, [:inventory_id]

    change_column :lineitems, :vat, :decimal
  end

  def self.down
    change_column :lineitems, :vat, :integer

    drop_table :prices
  end
end
