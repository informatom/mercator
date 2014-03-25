if CONFIG[:mesonic] == "on"

  class Mesonic::KontenstammAdresse < Mesonic::Sqlserver

    self.table_name = "T051"
    self.primary_key = "mesoprim"

    attr_accessible :firstname, :lastname, :c001, :c116, :c157, :c180, :c181, :c182, :C241, :c050,
                    :c051, :c052, :c123, :mesocomp, :mesoyear, :mesoprim

    scope :mesoyear, -> { where(mesoyear: Mesonic::AktMandant.mesoyear) }
    scope :mesocomp, -> { where(mesocomp: Mesonic::AktMandant.mesocomp) }
    default_scope { mesocomp.mesoyear }

    alias_attribute :street, :c050
    alias_attribute :city, :c052
    alias_attribute :to_hand, :c053
    alias_attribute :postal, :c051
    alias_attribute :land, :c123
    alias_attribute :firstname, :c180
    alias_attribute :lastname, :c181
    alias_attribute :tel_land, :c140
    alias_attribute :tel_city, :c141
    alias_attribute :telephone, :c019
    alias_attribute :fax, :c020
    alias_attribute :email, :c116
    alias_attribute :web , :c128

    attr_accessor :name

    validates_presence_of :name, :on => :create
    validates_presence_of :street
    validates_presence_of :city
    validates_presence_of :postal

    # --- Instance Methods --- #

    def full_name
      [ self.firstname, self.lastname ].join(" ")
    end

    def telephone_full
      [ self.tel_land, self.tel_city, self.telephone ].join(" ")
    end

    def fax_full
      [ self.tel_land, self.tel_city, self.fax ].join(" ")
    end

    #--- Class Methods --- #

    def self.initialize_mesonic(billing_address: nil, kontonummer: nil)
      self.new(c157: 0, c182: 0, C241: 0,
               c050: billing_address.street,
               c051: billing_address.postalcode,
               c052: billing_address.city,
               c123: billing_address.country,
               c180: billing_address.name.split(/\s/).first,
               c181: billing_address.name.split(/\s/).last,
               c001: kontonummer,
               c116: billing_address.email_address.to_s,
               mesocomp: Mesonic::AktMandant.mesocomp,
               mesoyear: Mesonic::AktMandant.mesoyear,
               mesoprim: kontonummer.to_s + "-" + Mesonic::AktMandant.mesocomp + "-" + Mesonic::AktMandant.mesoyear.to_s)
    end
  end
end