module MercatorBechlem
  class Base < ActiveRecord::Base

    self.table_name = "VCATEGORY"
    self.primary_key = "IDCATEGORY"

    def parent_category_id
      cat_id = self.IDCATEGORY.to_s
      cat_id[0..(9 - ( cat_id.count("0") + 2 ) ) ]
    end

    def self.top_category_id
      1452
    end

    def self.by_category_id( category_id = self.top_category_id )
      cat_id = category_id.to_s
      cat_id = cat_id + "0" * (9 - cat_id.length )
      self.find_by_sql [
      "SELECT c.* FROM VCATEGORY c, ITEM2ITEM i2i
      WHERE i2i.idItem = c.idCategory
      AND i2i.idParItem = ?
      ORDER by idCategory", cat_id.to_i
      ]
    end

    # --- Instance Methods --- #
    def readonly?  # prevents unintentional changes
      true
    end
  end
end