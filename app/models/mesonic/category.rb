class Mesonic::Category < Mesonic::Web

  set_primary_key :MESOKEY
  self.table_name = "WT014"

  has_one :parent, :class_name => "Mesonic::Category", :foreign_key => "C001", :primary_key => :parent_key
  has_many :categories_products, :class_name => "Mesonic::CategoryProduct", :foreign_key => "C000",
           :primary_key => :category_products_primary_key
  has_one :information, :class_name => "Mesonic::CategoryInformation", :foreign_key => "C000", :primary_key => :info_key

  def mesonic_products
    self.categories_products.collect(&:mesonic_products).flatten
  end

  def category_products_primary_key
    self.C004.to_s
  end

  def parent_key
    arr = self.C001.split("-")
    arr[ self.C002.to_i - 1] = "00"
    arr.join("-")
  end


  def info_key
    self.C004.to_i
  end
end