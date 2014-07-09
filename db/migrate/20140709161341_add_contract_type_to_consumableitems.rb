class AddContractTypeToConsumableitems < ActiveRecord::Migration
  def self.up
    add_column :consumableitems, :contract_type, :string
  end

  def self.down
    remove_column :consumableitems, :contract_type
  end
end
