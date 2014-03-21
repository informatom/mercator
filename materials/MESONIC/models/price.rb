class Mesonic::Price < Mesonic::Cwl
  set_primary_key :MESOKEY
  self.table_name = "T043"

  def self.price_column
    :c013
  end

   default_scope :conditions => {:mesoyear => Mesonic::AktMandant.mesoyear, :mesocomp => Mesonic::AktMandant.mesocomp, :c002 => 3 },
                 :select => '[t043].[c002], [t043].[c001], [t043].[c003],[t043].[c013]'

  # find customer specific price (for a given account_number)
  named_scope :by_customer, lambda { |account_number| { :conditions => { :c003 => account_number, :c001 => "3" } } }

  named_scope :for_date, lambda { |date|
    {:conditions => [ " ( ( t043.c004 IS NULL  OR t043.c004 <= ? ) AND ( t043.c005 IS NULL OR t043.c005 >= ? ) )", date, date ] }
  }

  # find customer-group specific price (for a given account_number)
  named_scope :by_group_through_customer, lambda { |account_number|
    { :joins => "INNER JOIN [t054] ON [t054].[mesoyear] = #{Mesonic::AktMandant.mesoyear} AND [t054].[mesocomp] = #{Mesonic::AktMandant.mesocomp}",
      :conditions => ["[t054].[c112] = ? AND [t043].[c003] = CAST([t054].[c072] as varchar(12)) ", account_number ] }
    }

  named_scope :group, lambda { |account_number|
    {
      :joins => "INNER JOIN [t004] ON [t004].[mesoyear] = #{Mesonic::AktMandant.mesoyear} AND [t004].[mesocomp] = #{Mesonic::AktMandant.mesocomp} " +
        " INNER JOIN [t054] ON [t054].[mesoyear] = #{Mesonic::AktMandant.mesoyear} AND [t054].[mesocomp] = #{Mesonic::AktMandant.mesocomp} AND ([t004].[c001] = [t054].[c077])" +
        "	INNER JOIN [t286] ON (#{Mesonic::AktMandant.mesocomp} = [t286].[mesocomp]) AND (#{Mesonic::AktMandant.mesoyear} = [t286].[mesoyear]) AND (CStr([t004].[c004]) = [t286].[c000]) ",
      :conditions => ["[t054].[c112] = ?", account_number ]
    }
  }

  # find customer-group specific price (for a given customer-group-number)
  named_scope :by_group, lambda { |group|
    { :conditions => { :c003 => group, :c001 => "2" } }
  }

  # find regular price
  named_scope :regular, { :conditions => { :c001 => "1" } }

  def price
    self.send( self.class.price_column )
  end

  alias :to_s :price
end