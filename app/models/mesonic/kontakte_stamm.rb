class Mesonic::KontakteStamm < Mesonic::Cwl

  def self.table_name
    "T045"
  end

  set_primary_key "c000"

  default_scope self.mesonic_default_scope

  belongs_to :kontenstamm, :class_name => "Mesonic::Kontenstamm", :foreign_key => 'c039'
  belongs_to :kontenstamm_adresse, :class_name => "Mesonic::KontenstammAdresse", :foreign_key => 'c039'
  belongs_to :kontenstamm_fakt, :class_name => "Mesonic::KontenstammFakt", :foreign_key => 'c039'

  [ :kunde?, :interessent? ].each { |m| delegate m, :to => :kontenstamm }

  alias_attribute :email,:c025
  alias_attribute :kontonummer, :c039

  class << self ;
    def next_kontaktenummer
      last_kontaktenummer = find( :all, :select => "c000", :order => "c000 DESC", :limit => 1 ).first.c000.to_i
      while( kontaktenummer_exists?( last_kontaktenummer ) )
        last_kontaktenummer += 1
      end
      last_kontaktenummer
    end

    def kontaktenummer_exists?(n)
      !find( :all, :conditions => { :c000 => n } ).empty?
    end
  end
end