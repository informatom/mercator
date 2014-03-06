class Mesonic::OldWebAccount < Mesonic::Web

  self.table_name = "WT003"
  set_primary_key :MESOKEY

  has_one :mesonic_account, :class_name => "::Mesonic::Account", :foreign_key => "C025", :primary_key => "C000"
end