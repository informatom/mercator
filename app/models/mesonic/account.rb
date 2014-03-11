class Mesonic::Account < Mesonic::Cwl

  self.table_name = "T045"
  set_primary_key "mesoprim"
  default_scope mesocomp.mesoyear

  has_one :kontenstamm,         :class_name => "::Mesonic::Kontenstamm",        :foreign_key => "c002", :primary_key => "c039"
  has_one :kontenstamm_adresse, :class_name => "::Mesonic::KontenstammAdresse", :foreign_key => "c001", :primary_key => "c039"
  has_one :kontenstamm_fakt,    :class_name => "::Mesonic::KontenstammFakt",    :foreign_key => "c112", :primary_key => "c039"
  has_one :kontenstamm_fibu,    :class_name => "::Mesonic::KontenstammFibu",    :foreign_key => "c104", :primary_key => "c039"

  [ :kontonummer, :kunde?, :interessent? ].each { |m| delegate m, :to => :kontenstamm }
  [ :telephone, :fax, :uid_number ].each { |m| delegate m, :to => :kontenstamm_adresse }

  scope :by_email, ->(email) { where(c025: email) }

  delegate_attribute :email, :c025
  delegate_attribute :account_number ,:c039
  delegate_attribute :uid_number, :c038

  def full_name
    [self.c001, self.c002 ].join(" ")
  end
end