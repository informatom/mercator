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
end