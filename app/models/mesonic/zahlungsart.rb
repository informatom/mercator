class Mesonic::Zahlungsart < Mesonic::Sqlserver

  self.table_name = "T286"
  self.primary_key = "c000"

  scope :mesoyear, -> { where(mesoyear: Mesonic::AktMandant.mesoyear) }
  scope :mesocomp, -> { where(mesocomp: Mesonic::AktMandant.mesocomp) }
  default_scope { mesocomp.mesoyear }

  scope :by_account_number, ->(account_number) do
    joins("INNER JOIN [t004] ON [t004].[mesoyear] = #{Mesonic::AktMandant.mesoyear} AND " +
          "[t004].[mesocomp] = #{Mesonic::AktMandant.mesocomp} AND [t004].[c004] = [t286].[c000]" +
          "INNER JOIN [t054] ON [t054].[mesoyear] = #{Mesonic::AktMandant.mesoyear} AND " +
          "[t054].[mesocomp] = #{Mesonic::AktMandant.mesocomp} AND [t004].[c001] = [t054].[c077]")
    .where("[t004].[c000] = 'faktzahl'").where("[t054].[c112] = ?", account_number)
  end

  # --- Instance Methods --- #

  def readonly?  # prevents unintentional changes
    true
  end

end