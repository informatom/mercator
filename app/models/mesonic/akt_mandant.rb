if CONFIG[:mesonic] == "on"

class Mesonic::AktMandant < Mesonic::Sqlserver

  self.table_name = "AktMandant"
  self.primary_key = "mesocomp"

  # --- Class Methods --- #

  def self.mesocomp
    self.first.mesocomp
  end

  def self.mesoyear
    self.first.mesoyear
  end

  def self.mesocomp_and_year
    [self.first.mesocomp, self.first.mesoyear]
  end

  # --- Instance Methods --- #

  def readonly?  # prevents unintentional changes
    true
  end
end

end