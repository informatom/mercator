if CONFIG[:mesonic] == "on"

  class Mesonic::KontenstammFibu < Mesonic::Sqlserver

    self.table_name = "T058"
    self.primary_key = "mesoprim"

    attr_accessible :c005, :c012, :c007, :c008, :c100, :c104, :c009, :c163, :c174, :C185, :c153, :c164, :c175,
                    :c176, :C186, :c067, :C189, :c058, :c124, :c135, :C190, :c057, :c059, :c114, :c136, :c115,
                    :c137, :c006, :c061, :c063, :c151, :c173, :c177, :mesocomp, :mesoyear, :mesoprim

    scope :mesoyear, -> { where(mesoyear: Mesonic::AktMandant.mesoyear) }
    scope :mesocomp, -> { where(mesocomp: Mesonic::AktMandant.mesocomp) }
    default_scope { mesocomp.mesoyear }

    alias_attribute :bkz1, :c007
    alias_attribute :bkz2, :c008
    alias_attribute :zahlungskondition_fibu, :c100
    alias_attribute :kontonummer, :c104

    # --- Class Methods --- #

    def self.initialize_mesonic(kontonummer: nil)
      self.new(c005: 0, c006: 0, c009: 0, c012: 0, c057: 0, c058: 0, c059: 0, c061: 0, c063: 0, c067: 0,
               c114: 0, c115: 0, c124: 0, c135: 0, c136: 0, c137: 0, c151: 0, c153: 0, c164: 0, c173: 0,
               c174: 0, c175: 0, c176: 0, C185: 0, C186: 0, C189: 0, C190: 0,
               c007: "1300",
               c008: "1300",
               c100: "017",
               c104: kontonummer,
               c177: kontonummer,
               c163: -1,
               mesocomp: Mesonic::AktMandant.mesocomp,
               mesoyear: Mesonic::AktMandant.mesoyear,
               mesoprim: kontonummer.to_s + "-" + Mesonic::AktMandant.mesocomp + "-" + Mesonic::AktMandant.mesoyear.to_s)
    end
  end
end