require 'spec_helper'

describe ConsumablesController, :type => :controller do

  before :each do
    no_redirects and act_as_user

    @active_product = create(:product, number: "active_product")
    create(:inventory, product_id: @active_product.id,
                       alternative_number: "C8753A")
    create(:inventory, product_id: @active_product.id,
                       alternative_number: "C3909X")

    @inactive_product = create(:product, number: "inactive_product",
                                         state: "inactive")
    create(:inventory, product_id: @inactive_product.id,
                       alternative_number: "C8753A")
    create(:inventory, product_id: @inactive_product.id,
                       alternative_number: "C3909X")
  end


  describe "products" do
    it "finds the printer" do
      get :products, id: 40088220
      expect(assigns(:printer)).to eql "40088220"
    end

    it "finds the printer description" do
      get :products, id: 40088220
      expect(assigns(:printer_description)).to eql "CM 8000 Series"
    end

    it "finds the products" do
      get :products, id: 40088220
      expect(assigns(:products)).to eql [@active_product, @inactive_product]
    end

    it "finds the active products" do
      get :products, id: 40088220
      expect(assigns(:active_products)).to eql [@active_product]
    end

    it "finds the printerseries" do
      get :products, id: 40088220
      expect(assigns(:printerseries)).to eql "CM"
    end
  end


  describe "printers" do
    it "finds the printerserie" do
      get :printers, id: "CM"
      expect(assigns(:printerserie)).to eql "CM"
    end

    it "finds the printer_series" do

      get :printers, id: "CM"
      expect(assigns(:printer_series).count > 2700 ).to eql true
    end

    it "finds the printer_series_names" do
      @printer_series_names = ["Business InkJet", "CM", "Color Copier", "Color InkJet",
                               "Color LaserJet", "CopyJet", "CP", "DesignJet", "DesignJet H",
                               "DesignJet L", "DesignJet T", "DesignJet Z", "DeskJet", "DeskJet D",
                               "DeskJet F", "Deskwriter", "Digital Copier", "Digital Copier Printer",
                               "Envy", "Fax", "LaserJet", "LaserJet M", "LaserJet P", "LaserJet Pro",
                               "LineJet", "Mopier", "OfficeJet", "OfficeJet H", "OfficeJet J",
                               "OfficeJet Pro", "OfficeJet Pro K", "OfficeJet Pro L", "OfficeJet R",
                               "OfficeJet T", "OfficeJet V", "PaintJet", "Paintwriter", "Photo Printer",
                               "Photosmart", "Photosmart A", "Photosmart B", "Photosmart C",
                               "Photosmart D", "Photosmart PE", "Photosmart PM", "Photosmart Premium",
                               "Photosmart Pro B", "PSC", "QuietJet", "Scitex"]

      get :printers, id: "CM"
      expect(assigns(:printer_series_names)).to eql @printer_series_names
    end

    it "finds the printer_names" do
      get :printers, id: "CM"
      expect(assigns(:printer_names)).to eql ["CM 8000 Series", "CM 8050", "CM 8060"]
    end

    it "finds the printers" do
      @printers = MercatorBechlem::VitemPrinter.where(IDITEM: [40088220, 40070206, 40070207]).to_a
      get :printers, id: "CM"
      expect(assigns(:printers).to_a).to match_array @printers
    end

    it "finds all printer names for printer series All" do
      get :printers, id: "All"
      expect(assigns(:printer_names).count > 2900).to eql true
    end
  end


  describe "category"  do
    it "finds the category" do
      get :category, id: "145221110"
      expect(assigns(:category).DESCRIPTION).to eql "Druckkopf schwarz\r"
    end

    it "finds the category for All" do
      get :category, id: "All"
      expect(assigns(:category).DESCRIPTION).to eql "Verbrauchsmaterial\r"
    end

    it "finds the ancestors" do
      @ancestors = ["InkJet\r", "Druckkopf\r", "Druckkopf schwarz / grau\r"]
      get :category, id: "145221110"
      expect(assigns(:ancestors).*.DESCRIPTION).to eql @ancestors
    end

    it "finds the children" do
      get :category, id: "All"
      expect(assigns(:children).count).to eql 6
    end

    it "finds the printers" do
      get :category, id: "145211100"  # Toner schwarz
      expect(assigns(:printers).count > 200).to eql true
    end

    it "finds the products" do
      get :category, id: "145211100" # Toner schwarz
      expect(assigns(:products)).to eql [@active_product, @inactive_product]
    end

    it "finds the active products" do
      get :category, id: "145211100" # Toner schwarz
      expect(assigns(:active_products)).to eql [@active_product]
    end
  end
end