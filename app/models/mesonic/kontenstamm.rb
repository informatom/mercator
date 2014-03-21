class Mesonic::Kontenstamm < Mesonic::Sqlserver

  self.table_name = "T055"
  self.primary_key = "mesoprim"

  alias_attribute :name, :c003
  alias_attribute :firma, :name
  alias_attribute :kontonummer, :c002

  default_scope mesocomp.mesoyear
  scope :interessenten, -> { where("mesoprim LIKE 1I%").select(:coo2).order(c002 desc).limit(1) }
  scope :interessent, -> { where("mesoprim LIKE 1I%") }

  has_one :kontenstamm_adresse, :class_name => "Mesonic::KontenstammAdresse", :foreign_key => "C001", :primary_key => "c002"

  # --- Class Methods --- #

  def self.next_kontonummer
    last_kontonummer = self.interessenten.first.c002.split("I").last.to_i
    while  kontonummer_exists?( "1I#{last_kontonummer}" )
      last_kontonummer += 1
    end
    "1I#{last_kontonummer}"
  end

  def self.kontonummer_exists?( k )
    self.where(c002: k).any?
  end

  # --- Instance Methods --- #
  def kunde?
    self.c004.to_i == 2 # 2... Kunde, 4 ... Interessent
  end

  def interessent?
    !self.kunde?
  end
end