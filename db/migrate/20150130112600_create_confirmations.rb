class CreateConfirmations < ActiveRecord::Migration
  def self.up
    create_table :mercator_mpay24_confirmations do |t|
      t.string :operation
      t.string :tid
      t.string :status
      t.string :price
      t.string :currency
      t.string :p_type
      t.string :brand
      t.string :mpaytid
      t.string :user_field
      t.string :orderdesc
      t.string :customer
      t.string :customer_email
      t.string :language
      t.string :customer_id
      t.string :profile_id
      t.string :profile_status
      t.string :filter_status
      t.string :appr_code
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :mercator_mpay24_confirmations
  end
end
