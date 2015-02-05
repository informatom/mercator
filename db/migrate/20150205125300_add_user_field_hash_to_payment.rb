class AddUserFieldHashToPayment < ActiveRecord::Migration
  def self.up
    add_column :mercator_mpay24_payments, :user_field_hash, :string
  end

  def self.down
    remove_column :mercator_mpay24_payments, :user_field_hash
  end
end
