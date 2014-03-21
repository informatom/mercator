class Mesonic::KontenstammFibu < Mesonic::Sqlserver

  self.table_name = "T058"
  self.primary_key = "mesoprim"

  default_scope mesocomp.mesoyear

  alias_attribute :bkz1, :c007
  alias_attribute :bkz2, :c008
  alias_attribute :zahlungskondition_fibu, :c100
  alias_attribute :kontonummer, :c104
end