class Mesonic::KontenstammAdresse < Mesonic::Cwl

  def self.table_name
    "T051"
  end

  set_primary_key "mesoprim"

  default_scope self.mesonic_default_scope

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

  def full_name
    [ self.firstname, self.lastname ].join(" ")
  end

  def telephone_full
    [ self.tel_land, self.tel_city, self.telephone ].join(" ")
  end

  def fax_full
    [ self.tel_land, self.tel_city, self.fax ].join(" ")
  end
end