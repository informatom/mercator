if CONFIG[:mesonic] == "on"

class Mesonic::Price < Mesonic::Sqlserver

  self.table_name = "T043"
  self.primary_key = :MESOKEY

  scope :mesoyear, -> { where(mesoyear: Mesonic::AktMandant.mesoyear) }
  scope :mesocomp, -> { where(mesocomp: Mesonic::AktMandant.mesocomp) }
  default_scope { mesocomp.mesoyear.where(c002: 3).pluck(:c002, :c001, :c003, :c013) }

  alias_attribute :price_column, :c013

  # find customer specific price (for a given account_number)
  scope :by_customer, ->(account_number) { where(c003: account_number, c001: "3") }

  scope :for_date, ->(date) { where(" ( ( t043.c004 IS NULL  OR t043.c004 <= ? ) AND ( t043.c005 IS NULL OR t043.c005 >= ? ) )", date, date ) }

  # find customer-group specific price (for a given account_number)
  scope :by_group_through_customer, ->(account_number) do
    joins("INNER JOIN [t054] ON [t054].[mesoyear] = #{Mesonic::AktMandant.mesoyear} AND [t054].[mesocomp] = #{Mesonic::AktMandant.mesocomp}")
    .where("[t054].[c112] = ?, account_number").where("[t043].[c003] = CAST([t054].[c072] as varchar(12)) ")
  end

  scope :group, ->(account_number) do
    joins("INNER JOIN [t004] ON [t004].[mesoyear] = #{Mesonic::AktMandant.mesoyear} AND [t004].[mesocomp] = #{Mesonic::AktMandant.mesocomp} " +
          " INNER JOIN [t054] ON [t054].[mesoyear] = #{Mesonic::AktMandant.mesoyear} AND " +
          "[t054].[mesocomp] = #{Mesonic::AktMandant.mesocomp} AND ([t004].[c001] = [t054].[c077])" +
          "	INNER JOIN [t286] ON (#{Mesonic::AktMandant.mesocomp} = [t286].[mesocomp]) AND " +
          "(#{Mesonic::AktMandant.mesoyear} = [t286].[mesoyear]) AND (CStr([t004].[c004]) = [t286].[c000]) ")
    .where("[t054].[c112] = ?", account_number)
  end

  # find customer-group specific price (for a given customer-group-number)
  scope :by_group, ->(group) { where(c003: group, c001: "2") }

  # find regular price
  scope :regular, -> { where(c001: "1") }

  def price
    self.send( self.class.price_column )
  end

  alias :to_s :price
end

end