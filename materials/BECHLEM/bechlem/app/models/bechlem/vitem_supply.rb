class Bechlem::VitemSupply < Bechlem::Base
  def self.table_name ; "VITEM_SUPPLY" ; end
  set_primary_key 'IDITEM'

  class << self ;
    def for_category_id( brand, category_id )
      cat_id = category_id.to_s.gsub("0", "")
      self.find_by_sql [
      "select *
        from VITEM_SUPPLY
        where idCategory like ?
        and brand=?
        order by artnr", "#{cat_id}%", brand
      ]
    end
  end
end