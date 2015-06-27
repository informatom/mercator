require 'spec_helper'

describe MercatorIcecat::Access do

  # ---  Class Methods  --- #

  describe "open_uri_options" do
    it "returnes open_uri_options" do
      expect(MercatorIcecat::Access.open_uri_options[:http_basic_authentication][0]).to eql "ivelmic"
    end
  end


  describe "download_index" do
    it "downloads the (daily) index" do
      filename = Rails.root.join("vendor","catalogs",Date.today.to_s + "-index.xml")
      File.delete(filename) if File.exist?(filename)
      expect(File).not_to exist(filename)
      MercatorIcecat::Access.download_index(full: false)
      expect(File).to exist(filename)
    end

# Takes quite some time and loads some 386 MB of data, so disabled ...
    # it "downloads the (full) index" do
    #   filename = Rails.root.join("vendor","catalogs","files.index.xml")
    #   File.delete(filename) if File.exist?(filename)
    #   expect(File).not_to exist(filename)
    #   MercatorIcecat::Access.download_index(full: true)
    #   expect(File).to exist(filename)
    # end
  end


  describe "product" do
    it "downloads xml file for for icecat_product_id" do
      @metadatum = create(:metadatum)
      expect(MercatorIcecat::Access.product(product_id: @metadatum.prod_id)
                                   .length > 50000).to eql true
    end

    it "returns the product url for path" do
      @metadatum = create(:metadatum)
      expect(MercatorIcecat::Access.product(path: "/xml_s3/xml_server3.cgi?prod_id=D9190B;vendor=HP;lang=int;output=productxml")
                                   .length > 50000).to eql true
    end
  end


  describe "product_url" do
    it "returns the product url" do
      @metadatum = create(:metadatum)
      expect(MercatorIcecat::Access.product_url(product_id: @metadatum.prod_id)).to eql "http://data.icecat.biz/xml_s3/xml_server3.cgi?prod_id=D9190B;vendor=HP;lang=int;output=productxml"
    end
  end
end