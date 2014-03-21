class Bechlem::Vitem2item < Bechlem::Base
  def self.table_name ; :item2item_temp ; end
  set_primary_key 'IDITEM'
  belongs_to :item, :class_name => "Bechlem::Vitem", :primary_key => "IDITEM"
  belongs_to :part_item, :class_name => "Bechlem::Vitem", :primary_key => "IDPARTITEM"
end