class Mesonic::Belegart < Mesonic::Cwl

  self.table_name = "T357"
  set_primary_key "C000"
  default_scope mesocomp.mesoyear
end