if CONFIG[:mesonic] == "on"

  class Mesonic::KontakteStamm < Mesonic::Sqlserver

    self.table_name = "T045"
    self.primary_key = "mesoprim"

    attr_accessible :c039, :id, :c000, :c025, :c033, :c035, :c040, :c042, :c043, :c054,
                    :c059, :c060, :C061, :mesocomp, :mesoyear, :mesoprim

    scope :mesoyear, -> { where(mesoyear: Mesonic::AktMandant.mesoyear) }
    scope :mesocomp, -> { where(mesocomp: Mesonic::AktMandant.mesocomp) }
    default_scope { mesocomp.mesoyear }

    scope :by_email, ->(email) { where(c025: email) }

    alias_attribute :email,:c025
    alias_attribute :kontonummer, :c039
    alias_attribute :account_number ,:c039
    alias_attribute :uid_number, :c038

    belongs_to :kontenstamm,         :class_name => "Mesonic::Kontenstamm",        :foreign_key => 'c039'
    belongs_to :kontenstamm_adresse, :class_name => "Mesonic::KontenstammAdresse", :foreign_key => 'c039'
    belongs_to :kontenstamm_fakt,    :class_name => "Mesonic::KontenstammFakt",    :foreign_key => 'c039'
    belongs_to :kontenstamm_fibu,    :class_name => "Mesonic::KontenstammFibu",    :foreign_key => "c039"

    delegate :kunde?, :interessent?, to: :kontenstamm
    delegate :telephone, :fax, :uid_number, to: :kontenstamm_adresse

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

    def self.initialize_mesonic(user: nil, kontonummer: nil, kontaktenummer: nil)
      self.new(c033: 0, c035: 0, c040: 1, c042: 0, c043: 0, c054: 0, c059: 0, c060: 0,
               c039:     kontonummer,
               id:       kontaktenummer,
               c000:     kontaktenummer,
               c025:     user.email_address.to_s,
               C061:     kontaktenummer,
               mesocomp: Mesonic::AktMandant.mesocomp,
               mesoyear: Mesonic::AktMandant.mesoyear,
               mesoprim: kontaktenummer.to_s + "-" + Mesonic::AktMandant.mesocomp + "-" + Mesonic::AktMandant.mesoyear.to_s)
    end

    # --- Instance Methods --- #
    def full_name
      self.c001 + "-" + self.c002
    end
  end
end