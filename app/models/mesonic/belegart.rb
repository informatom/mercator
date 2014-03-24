class Mesonic::Belegart < Mesonic::Sqlserver

  self.table_name = "T357"
  self.primary_key = "C000"

  scope :mesoyear, -> { where(mesoyear: Mesonic::AktMandant.mesoyear) }
  scope :mesocomp, -> { where(mesocomp: Mesonic::AktMandant.mesocomp) }
  default_scope { mesocomp.mesoyear }

  # --- Instance Methods --- #

  def readonly?  # prevents unintentional changes
    true
  end
end