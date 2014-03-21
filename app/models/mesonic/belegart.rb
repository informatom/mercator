class Mesonic::Belegart < Mesonic::Sqlserver

  self.table_name = "T357"
  self.primary_key = "C000"

  default_scope mesocomp.mesoyear

  # --- Instance Methods --- #

  def readonly?  # prevents unintentional changes
    true
  end
end