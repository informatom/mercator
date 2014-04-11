class Admin::Catalog::ProductsController < Admin::CatalogController

  def import_icecat_xml
    @product = Product.find( params[:id] )

    @product.icecat_product_xml = params[:product][:icecat_product_xml] if( params[:product] && params[:product][:icecat_product_xml] )

    @product.import_icecat_xml
    @product.import_icecat_related_products
    @product.import_icecat_option_products
    @product.import_icecat_images
    @product.icecat_last_import = Time.now
  end
end