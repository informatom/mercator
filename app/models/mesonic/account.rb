class Mesonic::Account < Mesonic::Sqlserver

  self.table_name = "T045"
  self.primary_key = "mesoprim"

  scope :mesoyear, -> { where(mesoyear: Mesonic::AktMandant.mesoyear) }
  scope :mesocomp, -> { where(mesocomp: Mesonic::AktMandant.mesocomp) }
  default_scope { mesocomp.mesoyear }

  alias_attribute :email, :c025
  alias_attribute :account_number ,:c039
  alias_attribute :uid_number, :c038

  scope :by_email, ->(email) { where(c025: email) }

  has_one :kontenstamm,         :class_name => "Mesonic::Kontenstamm",        :foreign_key => "c002", :primary_key => "c039"
  has_one :kontenstamm_adresse, :class_name => "Mesonic::KontenstammAdresse", :foreign_key => "c001", :primary_key => "c039"
  has_one :kontenstamm_fakt,    :class_name => "Mesonic::KontenstammFakt",    :foreign_key => "c112", :primary_key => "c039"
  has_one :kontenstamm_fibu,    :class_name => "Mesonic::KontenstammFibu",    :foreign_key => "c104", :primary_key => "c039"

  delegate :kontonummer, :kunde?, :interessent?, to: :kontenstamm
  delegate :telephone, :fax, :uid_number, to: :kontenstamm_adresse

  # --- Instance Methods --- #
  def full_name
    [self.c001, self.c002 ].join(" ")
  end
end