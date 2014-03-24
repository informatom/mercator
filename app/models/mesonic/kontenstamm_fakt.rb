if CONFIG[:mesonic] == "on"

  class Mesonic::KontenstammFakt < Mesonic::Sqlserver

    self.table_name = "T054"
    self.primary_key =  "mesoprim"

    scope :mesoyear, -> { where(mesoyear: Mesonic::AktMandant.mesoyear) }
    scope :mesocomp, -> { where(mesocomp: Mesonic::AktMandant.mesocomp) }
    default_scope { mesocomp.mesoyear }

    scope :by_kontonummer, ->(account_number) { where(c112: account_number) }

    has_one :belegart,       :class_name => "Mesonic::Belegart",    :foreign_key => "c030", :primary_key => "c077"
    has_many :zahlungsarten, :class_name => "Mesonic::Zahlungsart", :foreign_key => "c000", :primary_key => "c077"

    # --- Class Methods --- #

    def self.initialize_mesonic(kontonummer: nil)
      self.new(c060: 0,
               c062: 0,
               c066: 3,
               c065: 99,
               c068: 0,
               c070: 0,
               c071: 0,
               c072: 0,
               c077: 21,
               c107: "017",
               c108: 0,
               c109: 0,
               c110: 0,
               c111: 0,
               c112: kontonummer,
               c113: 0,
               c120: 0,
               c121: 1,
               c132: 0,
               c133: 0,
               c134: 0,
               c148: 0,
               c149: 0,
               c150: 0,
               c171: 0,
               c183: 0,
               C184: 0,
               mesocomp: Mesonic::AktMandant.mesocomp,
               mesoyear: Mesonic::AktMandant.mesoyear,
               mesoprim: kontonummer + "-" + Mesonic::AktMandant.mesocomp + "-" + Mesonic::AktMandant.mesoyear)
    end
  end

end