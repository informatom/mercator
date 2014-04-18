class CrossSellingController < OpensteamController
  def show
    @material_categories = Bechlem::Vcategory.by_category_id.select { |s| s.IDCATEGORY == 145210000 || s.IDCATEGORY == 145220000 }
  end

  def printer_products
    @material_products = Bechlem::Vitem2item.IDITEM_eq( params[:printer] )
    @ivellio_products  = Product.inventory_AltArtNr1_eq_any(
                         @material_products.collect { |s| "#{s.ARTNR.gsub("\s", '')}" }.compact.uniq)
                         .descend_by_inventory_Artikeluntergruppe.uniq
  end

  def printer
    if params[:printerseries].nil? || params[:printerseries] == "All"
      @printer_series = Bechlem::VitemPrinter.find( :all,
        :select => "DISTINCT PRINTERSERIES",
        :conditions => ["brand = 'HP' AND printerseries IS NOT NULL"],
        :order => "PRINTERSERIES ASC"
      )
      @printer_series_names = @printer_series.collect(&:PRINTERSERIES)
      conditions = ["brand = 'HP'"]
    else
      conditions = ["brand = 'HP' AND printerseries = ?", params[:printerseries] ]
    end

    @printer = Bechlem::VitemPrinter.find( :all, :select => "CATEGORY, BRAND, DESCRIPTION, IDITEM",
                                           :conditions => conditions, :order => "DESCRIPTION ASC" )
    page.replace_html :select_printer, :partial => "printer_selector"
  end

  def category
    cat_id = params[:category_id].to_s
    cat_id = cat_id + "0" * (9 - cat_id.length )

    if params[:category_id].to_i == Bechlem::Vcategory.top_category_id
      @material_categories = Bechlem::Vcategory.by_category_id.select { |s| s.IDCATEGORY == 145210000 || s.IDCATEGORY == 145220000 }
    else
      @top_category = Bechlem::Vcategory.find_by_IDCATEGORY( cat_id )
      @material_categories = Bechlem::Vcategory.by_category_id( params[:category_id] )
      @material_products = Bechlem::VitemSupply.for_category_id( 'HP', params[:category_id] )
    end

    unless @material_products.empty? || cat_id.count("0") > 3
      @ivellio_products = Product.inventory_AltArtNr1_eq_any( @material_products.collect { |s| "#{s.ARTNR.gsub("\s", '')}" }.compact.uniq )
    end
  end
end