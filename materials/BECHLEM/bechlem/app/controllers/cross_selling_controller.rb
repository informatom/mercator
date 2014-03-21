class CrossSellingController < OpensteamController
  helper :all
  helper :products
  helper :ivellio_frontend

  before_filter :find_categories
  before_filter :set_empty_category

  layout "ivellio_shop"

  def show
    @material_categories = Bechlem::Vcategory.by_category_id.select { |s| s.IDCATEGORY == 145210000 || s.IDCATEGORY == 145220000 }
    @material_products = []
    @ivellio_products = []
    respond_to do |format|
      format.html
      format.js
    end
  end

  def printer_products
    @material_products = Bechlem::Vitem2item.IDITEM_eq( params[:printer] )
    @ivellio_products  = Product.inventory_AltArtNr1_eq_any(
      @material_products.collect { |s| "#{s.ARTNR.gsub("\s", '')}" }.compact.uniq
    ).descend_by_inventory_Artikeluntergruppe.uniq

    respond_to do |format|
      format.js {
        render :update do |page|
          page << "$('products_inner').setStyle({width:'#{( @ivellio_products.size + 1 ) * 185}px'});"
          page.replace_html :printer_product_list, :partial => "products/overview", :collection => @ivellio_products
          text = @ivellio_products.empty? ? "keine" : "#{@ivellio_products.size}"
          page.replace_html :printer_selector_results, "<br />Es wurden #{text} Produkt(e) gefunden!"
        end
      }
    end
  end

  def printer
    # BEGIN HAS 20130109
    # brand = "Hewlett Packard"
    brand = "HP"
    # END HAS 20130109

    @ivellio_products = []
    if params[:printerseries].nil? || params[:printerseries] == "All"
      @printer_series = Bechlem::VitemPrinter.find( :all,
        :select => "DISTINCT PRINTERSERIES",
        :conditions => ["brand = ? AND printerseries IS NOT NULL", brand ],
        :order => "PRINTERSERIES ASC"
      )
      @printer_series_names = @printer_series.collect(&:PRINTERSERIES)
      conditions = ["brand = ?", brand]
    else
      conditions = ["brand = ? AND printerseries = ?", brand, params[:printerseries] ]
    end

    @printer = Bechlem::VitemPrinter.find( :all, :select => "CATEGORY, BRAND, DESCRIPTION, IDITEM",  :conditions => conditions, :order => "DESCRIPTION ASC" )
    respond_to do |format|
      format.html
      format.js {
        render :update do |page|
          page.replace_html :select_printer, :partial => "printer_selector"
        end
      }
    end
  end

  def category

    # BEGIN HAS 20130109
    # brand = "Hewlett Packard"
    brand = "HP"
    # END HAS 20130109

    cat_id = params[:category_id].to_s
    cat_id = cat_id + "0" * (9 - cat_id.length )

    if params[:category_id].to_i == Bechlem::Vcategory.top_category_id
      @material_categories = Bechlem::Vcategory.by_category_id.select { |s| s.IDCATEGORY == 145210000 || s.IDCATEGORY == 145220000 }
      @material_products = []
      @ivellio_products = []
    else
      @top_category = Bechlem::Vcategory.find_by_IDCATEGORY( cat_id )
      @material_categories = Bechlem::Vcategory.by_category_id( params[:category_id] )
      @material_products = Bechlem::VitemSupply.for_category_id( brand, params[:category_id] )
    end

    if @material_products.empty? || cat_id.count("0") > 3
      @ivellio_products = []
    else
      @ivellio_products = Product.inventory_AltArtNr1_eq_any( @material_products.collect { |s| "#{s.ARTNR.gsub("\s", '')}" }.compact.uniq )
    end

    respond_to do |format|
      format.html
      format.js {
        render :update do |page|
          page.replace_html :material_products, :partial => "material_products"
        end
      }
    end
  end

  private
  def set_empty_category
    @category = Category.new
  end
end