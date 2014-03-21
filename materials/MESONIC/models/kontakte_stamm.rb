class Mesonic::KontakteStamm < Mesonic::Cwl

  self.table_name = "T045"
  set_primary_key "c000"

  default_scope mesocomp.mesoyear

  belongs_to :kontenstamm, :class_name => "Mesonic::Kontenstamm", :foreign_key => 'c039'
  belongs_to :kontenstamm_adresse, :class_name => "Mesonic::KontenstammAdresse", :foreign_key => 'c039'
  belongs_to :kontenstamm_fakt, :class_name => "Mesonic::KontenstammFakt", :foreign_key => 'c039'

  [ :kunde?, :interessent? ].each { |m| delegate m, :to => :kontenstamm }

  alias_attribute :email,:c025
  alias_attribute :kontonummer, :c039

  class << self ;
    def next_kontaktenummer
      last_kontaktenummer = self.select(:c000).order(c000: :desc).limit(1).first.c000.to_i
      while kontaktenummer_exists?( last_kontaktenummer )
        last_kontaktenummer += 1
      end
      last_kontaktenummer
    end

    def kontaktenummer_exists?(n)
      self.where(c000: n).any?
    end
  end
end