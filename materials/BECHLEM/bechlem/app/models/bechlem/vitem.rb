class Bechlem::Vitem < Bechlem::Base
  def self.table_name ; 'vitem' ; end
  set_primary_key 'IDITEM'
  has_many :item2items, :class_name => "Bechlem::Vitem2item", :foreign_key => "IDITEM"
end