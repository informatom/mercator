class IcecatJob
  def import_icecat_xml_for_product
    return true unless @product_id
    p = ::Product.find( @product_id )
    return true unless p

    if imd = IcecatMetaData.find_by_prod_id( p.icecat_article_number )
      p.icecat_product_xml = imd.path
      p.icecat_product_id  = imd.product_id
      p.icecat_category_id = imd.cat_id
    else
      return false
    end

    p.import_icecat_xml
    p.import_icecat_related_products
    p.import_icecat_option_products
    p.import_icecat_images
    p.icecat_last_import = Time.now
    p.save
    p.clear_icecat_hash
  end

  def import_icecat_meta_data
    for_each_product(@products_scope || {}) { |product|
      if imd = IcecatMetaData.find_by_prod_id( product.icecat_article_number )
        product.icecat_product_xml = imd.path
        product.icecat_product_id  = imd.product_id
        product.icecat_category_id = imd.cat_id
      end
    }
  end

  def import_meta_data
    File.open( self.class.xml_index_filename ) do |f|
      f.each_line do |line|
        if line.include?("Supplier_id=\"1\"")
          hash = Hash.from_xml( line.gsub(/\s\>$/, "/>") )
          hash = hash['file']
          next if IcecatMetaData.find_by_product_id( hash['Product_ID'] )
          imd = IcecatMetaData.new
          imd.path = hash['path']
          imd.cat_id = hash['Catid']
          imd.product_id = hash['Product_ID']
          imd.icecat_updated_at = hash['Updated']
          imd.quality = hash['Quality']
          imd.supplier_id = hash['Supplier_id']
          imd.prod_id = hash['Prod_ID']
          imd.on_market = hash['On_Market']
          imd.model_name = hash['Model_Name']
          imd.product_view = hash['Product_View']
          imd.save
        end
      end
    end
  end

  def download_daily( filename )
    File.open( filename, "w" ) do |f|
      Icecat::Access.new.daily_index.read
    end
  end

  def download_index( filename )
    File.open( filename, "w" ) do |f|
      Icecat::Access.new.full_index.read
    end
  end
end