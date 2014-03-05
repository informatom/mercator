class Mesonic::AktMandant < Mesonic::Cwl

  def self.table_name
    "AktMandant"
  end

  set_primary_key :mesocomp

  class << self ;
    def mesocomp
      all.first.mesocomp
    end

    def mesoyear
      all.first.mesoyear
    end

    def both
      f = all.first
      [f.mesocomp, f.mesoyear]
    end
  end
end