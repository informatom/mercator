if CONFIG[:mesonic] == "on"

  class Mesonic::Kontenstamm < Mesonic::Sqlserver

    self.table_name = "T055"
    self.primary_key = "mesoprim"

    alias_attribute :name, :c003
    alias_attribute :firma, :name
    alias_attribute :kontonummer, :c002

    scope :mesoyear, -> { where(mesoyear: Mesonic::AktMandant.mesoyear) }
    scope :mesocomp, -> { where(mesocomp: Mesonic::AktMandant.mesocomp) }
    default_scope { mesocomp.mesoyear }

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

    def self.initialize_mesonic(user: nil, kontonummer: nil, timestamp: nil)
      self.new(c002:     kontonummer,
               c004:     "4",
               c003:     user.name,
               c084:     "",
               c086:     timestamp,
               c102:     kontonummer,
               c103:     kontonummer,
               c127:     "050-",
               c069:     2, ## KZ Änderungen durchgeführt ????
               c146:     0,
               c155:     0,
               c156:     0,
               c172:     0,
               C253:     0,
               C254:     0,
               mesosafe: 0,
               mesocomp: Mesonic::AktMandant.mesocomp,
               mesoyear: Mesonic::AktMandant.mesoyear,
               mesoprim: kontonummer + "-" + Mesonic::AktMandant.mesocomp + "-" + Mesonic::AktMandant.mesoyear)
    end

    # --- Instance Methods --- #
    def kunde?
      self.c004.to_i == 2 # 2... Kunde, 4 ... Interessent
    end

    def interessent?
      !self.kunde?
    end

  end
end