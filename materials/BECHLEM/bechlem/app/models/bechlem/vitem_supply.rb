module MercatorBechlem
  class VitemSupply < Base

    self.table_name = "VITEM_SUPPLY"
    self.primary_key = "IDITEM"

    def self.for_category_id( brand, category_id )
      cat_id = category_id.to_s.gsub("0", "")
      self.find_by_sql [
      "select * from VITEM_SUPPLY
        where idCategory like ?
        and brand=?
        order by artnr", "#{cat_id}%", brand
      ]
    end

    # --- Instance Methods --- #
    def readonly?  # prevents unintentional changes
      true
    end
  end
end
