if CONFIG[:mesonic] == "on"

class Mesonic::KontenstammFakt < Mesonic::Sqlserver

  self.table_name = "T054"
  self.primary_key =  "mesoprim"

  scope :mesoyear, -> { where(mesoyear: Mesonic::AktMandant.mesoyear) }
  scope :mesocomp, -> { where(mesocomp: Mesonic::AktMandant.mesocomp) }
  default_scope { mesocomp.mesoyear }

  scope :by_kontonummer, ->(account_number) { where(c112: account_number) }

  has_one :belegart,       :class_name => "Mesonic::Belegart",    :foreign_key => "c030", :primary_key => "c077"
  has_many :zahlungsarten, :class_name => "Mesonic::Zahlungsart", :foreign_key => "c000", :primary_key => "c077"
end

end