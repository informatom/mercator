class Mesonic::KontenstammFakt < Mesonic::Cwl

  self.table_name = "T054"
  set_primary_key "mesoprim"

  default_scope self.mesonic_default_scope

  has_one :belegart, :class_name => "Mesonic::Belegart", :foreign_key => "c030", :primary_key => "c077"
  has_many :zahlungsarten, :class_name => "Mesonic::Zahlungsart", :foreign_key => "c000", :primary_key => "c077"

  named_scope :by_kontonummer, lambda { |account_number| { :conditions => { :c112 => account_number } } }
end