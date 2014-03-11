class Mesonic::CategoryProduct < Mesonic::Web

  set_primary_key :MESOKEY
  self.table_name = "WT013"

  has_many :mesonic_products, :class_name => "Mesonic::Product", :foreign_key => "c078", :primary_key => :products_primary_key,
           :conditions => [" [v021].c038 IS NOT NULL AND [v021].c046 != ? AND [v021].c014 = ?","0","1" ]

  def products_primary_key
    self.C003.to_s
  end
end