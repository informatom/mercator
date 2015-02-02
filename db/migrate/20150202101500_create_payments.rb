class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :mercator_mpay24_payments do |t|
      t.string :merchant_id
      t.string :tid
      t.text :order_xml
      t.integer :order_id
      t.datetime :created_at
      t.datetime :updated_at
    end
    add_index :mercator_mpay24_payments, [:order_id]

    add_column :mercator_mpay24_confirmations, :payment_id, :integer
    add_index :mercator_mpay24_confirmations, [:payment_id]
  end

  def self.down
    drop_table :mercator_mpay24_payments

    remove_column :mercator_mpay24_confirmations, :payment_id
    remove_index :mercator_mpay24_confirmations,
                 :name => :index_mercator_mpay24_confirmations_on_payment_id rescue ActiveRecord::StatementInvalid
  end
end
