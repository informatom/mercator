if CONFIG[:mesonic] == "on"

class Mesonic::Order < Mesonic::Sqlserver

  self.table_name = "t025"
  self.primary_key = "C000"

  scope :mesoyear, -> { where(mesoyear: Mesonic::AktMandant.mesoyear) }
  scope :mesocomp, -> { where(mesocomp: Mesonic::AktMandant.mesocomp) }
  default_scope { mesocomp.mesoyear }
end

end