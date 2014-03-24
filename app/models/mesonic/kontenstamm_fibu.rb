if CONFIG[:mesonic] == "on"

  class Mesonic::KontenstammFibu < Mesonic::Sqlserver

    self.table_name = "T058"
    self.primary_key = "mesoprim"

    scope :mesoyear, -> { where(mesoyear: Mesonic::AktMandant.mesoyear) }
    scope :mesocomp, -> { where(mesocomp: Mesonic::AktMandant.mesocomp) }
    default_scope { mesocomp.mesoyear }

    alias_attribute :bkz1, :c007
    alias_attribute :bkz2, :c008
    alias_attribute :zahlungskondition_fibu, :c100
    alias_attribute :kontonummer, :c104

    # --- Class Methods --- #

    def self.mesonic_initialize(kontonummer: nil)
      self.new(c005: 0,
               c012: 0,
               c007: "1300",
               c008: "1300",
               c100: "017",
               c104: kontonummer,
               c009: 0,
               c163: -1,
               c174: 0,
               C185: 0,
               c153: 0,
               c164: 0,
               c175: 0,
               c176: 0,
               C186: 0,
               c067: 0,
               C189: 0,
               c058: 0,
               c124: 0,
               c135: 0,
               C190: 0,
               c057: 0,
               c059: 0,
               c114: 0,
               c136: 0,
               c115: 0,
               c137: 0,
               c006: 0,
               c061: 0,
               c063: 0,
               c151: 0,
               c173: 0,
               mesocomp: Mesonic::AktMandant.mesocomp,
               mesoyear: Mesonic::AktMandant.mesoyear,
               mesoprim: kontonummer + "-" + Mesonic::AktMandant.mesocomp + "-" + Mesonic::AktMandant.mesoyear)
    end
  end

end