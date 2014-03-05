class Mesonic::Kontenstamm < Mesonic::Cwl

  def self.table_name
    "T055"
  end

  set_primary_key "mesoprim"

  default_scope self.mesonic_default_scope

  KUNDE = 2
  INTERESSENT = 4

  has_one :kontenstamm_adresse, :class_name => "Mesonic::KontenstammAdresse", :foreign_key => "C001", :primary_key => "c002"

  class << self ;
    def next_kontonummer
      last_kontonummer = self.interessenten.first.c002.split("I").last.to_i
      while( kontonummer_exists?( "1I#{last_kontonummer}" ) )
        last_kontonummer += 1
      end
      "1I#{last_kontonummer}"
    end

    def kontonummer_exists?( k )
      !find( :all, :conditions => { :c002 => k } ).empty?
    end
  end

  named_scope :interessenten, { :conditions => ["mesoprim LIKE ?", "1I%" ], :select => "c002", :order => "c002 desc", :limit => 1 }
  named_scope :interessent, { :conditions => ["mesoprim LIKE ?", "1I%" ] }

  def name
    self.c003
  end

  def name=(val)
    self.c003 = val
  end

  def firma
    self.name
  end

  def kontonummer
    self.c002
  end

  def kunde?
    self.c004.to_i == Mesonic::Kontenstamm::KUNDE
  end

  def interessent?
    !self.kunde?
  end
end