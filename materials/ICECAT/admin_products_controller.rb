class Admin::Catalog::ProductsController < Admin::CatalogController

  before_filter :validate_sti_klass, :only => [ :new, :create ]

  def import_icecat_xml
    begin
      @product = Product.find( params[:id] )

      @product.icecat_product_xml = params[:product][:icecat_product_xml] if( params[:product] && params[:product][:icecat_product_xml] )

      @product.import_icecat_xml
      @product.import_icecat_related_products
      @product.import_icecat_option_products
      @product.import_icecat_images
      @product.icecat_last_import = Time.now
    rescue Exception => e
      flash[:error] = "Error: Icecat product xml could not be imported! Check the path of the xml file."
      redirect_to admin_catalog_product_path( @product )
      return
    end

    respond_to do |format|
      if @product.save && @product.errors.empty?
        flash[:info] = "Icecat product xml was successfully imported!"
      else
        flash[:error] = "Error: Icecat product xml could not be imported!"
      end
      format.html { redirect_to admin_catalog_product_path( @product ) }
    end
  end

  private

  def validate_sti_klass
    if params[:klass]
      @product_klass = params[:klass].classify.constantize
      unless @product_klass < Product
        @product = Product.new
        @product.errors.add( :type, "'#{params[:klass]} is not a Product-Class, 'doh" )
        render :action => :new
        return false
      end
    else
      @product_klass = Product
      return true
    end
  end
end