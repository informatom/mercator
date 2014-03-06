class Mesonic::AktMandant < Mesonic::Cwl

  self.table_name = "AktMandant"
  set_primary_key :mesocomp

  def self.mesocomp
    self.first.mesocomp
  end

  def self.mesoyear
    self.first.mesoyear
  end

  def self.both
    f = self.first
    [f.mesocomp, f.mesoyear]
  end
end