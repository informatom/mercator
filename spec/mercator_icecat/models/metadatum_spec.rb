require 'spec_helper'

describe MercatorIcecat::Metadatum do
  it "is valid with product, path, icecat_updated_at, quality, supplier_id, icecat_product_id," +
     "prod_id, product_number, cat_id, on_market, model_name and product_view" do
    expect(build :metadatum).to be_valid
  end

  it {should belong_to :product}


  # ---  Class Methods  --- #

  describe "import_catalog" do
    it "imports full metadata" do
      FileUtils.cp(Rails.root.join("vendor","engines","mercator_icecat", "materials", "icecat-test-index.xml"),
                   Rails.root.join("vendor","catalogs","files.index.xml"))

      MercatorIcecat::Metadatum.import_catalog(full: true)

      @metadatum = MercatorIcecat::Metadatum.first
      expect(@metadatum.path).to eql "export/freexml.int/INT/28461642.xml"
      expect(@metadatum.icecat_updated_at).to eql Time.new(2015, 06, 26, 06, 13 ,19)
      expect(@metadatum.quality).to eql "ICECAT"
      expect(@metadatum.supplier_id).to eql "1"
      expect(@metadatum.icecat_product_id).to eql "28461642"
      expect(@metadatum.product_number).to eql nil
      expect(@metadatum.cat_id).to eql "222"
      expect(@metadatum.on_market).to eql "1"
      expect(@metadatum.model_name).to eql "24uh"
      expect(@metadatum.product_view).to eql "485"

      File.delete(Rails.root.join("vendor","catalogs","files.index.xml"))
    end

    it "imports daily metadata" do
      FileUtils.cp(Rails.root.join("vendor","engines","mercator_icecat", "materials", "icecat-test-index.xml"),
                   Rails.root.join("vendor","catalogs", Date.today.to_s + "-index.xml"))

      MercatorIcecat::Metadatum.import_catalog(full: false)

      @metadatum = MercatorIcecat::Metadatum.first
      expect(@metadatum.path).to eql "export/freexml.int/INT/28461642.xml"
      expect(@metadatum.icecat_updated_at).to eql Time.new(2015, 06, 26, 06, 13 ,19)
      expect(@metadatum.quality).to eql "ICECAT"
      expect(@metadatum.supplier_id).to eql "1"
      expect(@metadatum.icecat_product_id).to eql "28461642"
      expect(@metadatum.product_number).to eql nil
      expect(@metadatum.cat_id).to eql "222"
      expect(@metadatum.on_market).to eql "1"
      expect(@metadatum.model_name).to eql "24uh"
      expect(@metadatum.product_view).to eql "485"

      File.delete(Rails.root.join("vendor","catalogs", Date.today.to_s + "-index.xml"))
    end
  end


  describe "assign_products" do
    before :each do
      @product = create(:product, alternative_number: "D9190B")
      @metadatum = create(:metadatum, product_id: nil)
    end

    it "works for missing products" do
      MercatorIcecat::Metadatum.assign_products(only_missing: true)
      @metadatum.reload
      expect(@metadatum.product_id).to eql @product.id
    end

    it "works for all products" do
      @metadatum.update(product_id: 17)

      MercatorIcecat::Metadatum.assign_products(only_missing: false)
      @metadatum.reload
      expect(@metadatum.product_id).to eql @product.id
    end
  end


  describe "download" do
    before :each do
      @filename = Rails.root.join("vendor", "xml", "1286.xml")
      File.delete(@filename) if File.exist?(@filename)
      @metadatum = create(:metadatum, product_id: 17)
    end

    after :each do
      File.delete(@filename) if File.exist?(@filename)
    end

    it "downloads from today, if requested" do
      MercatorIcecat::Metadatum.download(from_today: true)
      expect(File).to exist(@filename)
    end

    it "dosn't download, if today requested and updated_at is older" do
      @metadatum.update(updated_at: Time.now - 1.month)
      MercatorIcecat::Metadatum.download(from_today: true)
      expect(File).not_to exist(@filename)
    end

    it "downloads all, if requested" do
      MercatorIcecat::Metadatum.download(from_today: false)
      expect(File).to exist(@filename)
    end
  end


  # ---  Instance Methods  --- #

  describe "download" do
    before :each do
      @filename = Rails.root.join("vendor", "xml", "1286.xml")
      File.delete(@filename) if File.exist?(@filename)
      @metadatum = create(:metadatum, product_id: nil)
    end

    after :each do
      File.delete(@filename) if File.exist?(@filename)
    end

    it "downloads from today, if requested" do
      @metadatum.download(overwrite: true)
      expect(File).to exist(@filename)
    end

    it "returns nil, if no override and file exists" do
      @metadatum.download(overwrite: true)
      expect(@metadatum.download(overwrite: false)).to eql false
    end

    it "returns false, if no path in metadatum" do
      @metadatum.update(path: nil)
      expect(@metadatum.download(overwrite: true)).to eql false
    end
  end


  describe "update_product", focus: true do
  end
end