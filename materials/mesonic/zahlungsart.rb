class Mesonic::Zahlungsart < Mesonic::Cwl

  set_primary_key :c000
  self.table_name = "T286" ;

  default_scope mesocomp.mesoyear

  named_scope :by_account_number, lambda { |account_number|
   {
     :joins => "INNER JOIN [t004] ON [t004].[mesoyear] = #{Mesonic::AktMandant.mesoyear} AND [t004].[mesocomp] = #{Mesonic::AktMandant.mesocomp} AND [t004].[c004] = [t286].[c000]" +
     "INNER JOIN [t054] ON [t054].[mesoyear] = #{Mesonic::AktMandant.mesoyear} AND [t054].[mesocomp] = #{Mesonic::AktMandant.mesocomp} AND [t004].[c001] = [t054].[c077]",
     :conditions => ["[t004].[c000] = 'faktzahl' AND [t054].[c112] = ?", account_number ] }
   }

  scope :by_account_number, ->(account_number) {
     where(c000: 'faktzahl').where(c112: account_number).joins("INNER JOIN [t004] ON [t004].[mesoyear] = #{Mesonic::AktMandant.mesoyear} AND [t004].[mesocomp] = #{Mesonic::AktMandant.mesocomp} AND [t004].[c004] = [t286].[c000]" +
     "INNER JOIN [t054] ON [t054].[mesoyear] = #{Mesonic::AktMandant.mesoyear} AND [t054].[mesocomp] = #{Mesonic::AktMandant.mesocomp} AND [t004].[c001] = [t054].[c077]")
      }
end