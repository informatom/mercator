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

    it "imports daily metadata", focus: true do
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

  # ---  Instance Methods  --- #
end