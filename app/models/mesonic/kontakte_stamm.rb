if CONFIG[:mesonic] == "on"

class Mesonic::KontakteStamm < Mesonic::Sqlserver

  self.table_name = "T045"
  self.primary_key = "c000"

  scope :mesoyear, -> { where(mesoyear: Mesonic::AktMandant.mesoyear) }
  scope :mesocomp, -> { where(mesocomp: Mesonic::AktMandant.mesocomp) }
  default_scope { mesocomp.mesoyear }

  alias_attribute :email,:c025
  alias_attribute :kontonummer, :c039

  belongs_to :kontenstamm,         :class_name => "Mesonic::Kontenstamm",        :foreign_key => 'c039'
  belongs_to :kontenstamm_adresse, :class_name => "Mesonic::KontenstammAdresse", :foreign_key => 'c039'
  belongs_to :kontenstamm_fakt,    :class_name => "Mesonic::KontenstammFakt",    :foreign_key => 'c039'

  delegate :kunde?, :interessent?, to: :kontenstamm

  # --- Class Methods --- #

  def self.next_kontaktenummer
    last_kontaktenummer = self.select(:c000).order(c000: :desc).limit(1).first.c000.to_i
    while kontaktenummer_exists?( last_kontaktenummer )
      last_kontaktenummer += 1
    end
    last_kontaktenummer
  end

  def self.kontaktenummer_exists?(n)
    self.where(c000: n).any?
  end
end
end