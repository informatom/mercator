class Mesonic::KontenstammFibu < Mesonic::Cwl

  self.table_name = "T058"
  set_primary_key "mesoprim"

  default_scope self.mesonic_default_scope

  alias_attribute :bkz1, :c007
  alias_attribute :bkz2, :c008
  alias_attribute :zahlungskondition_fibu, :c100
  alias_attribute :kontonummer, :c104
end