class Mesonic::KontenstammFakt < Mesonic::Cwl

  self.table_name = "T054"
  set_primary_key "mesoprim"

  default_scope mesocomp.mesoyear
  named_scope :by_kontonummer, ->(account_number) { where(c112: account_number) }

  has_one :belegart, :class_name => "Mesonic::Belegart", :foreign_key => "c030", :primary_key => "c077"
  has_many :zahlungsarten, :class_name => "Mesonic::Zahlungsart", :foreign_key => "c000", :primary_key => "c077"
end