class Mesonic::Belegart < Mesonic::Cwl

  def self.table_name
    "T357"
  end

  set_primary_key "C000"

  default_scope self.mesonic_default_scope
end