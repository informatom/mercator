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

# Takes quite some time, so disabled ...
    # it "downloads the (full) index" do
    #   filename = Rails.root.join("vendor","catalogs","files.index.xml")
    #   File.delete(filename) if File.exist?(filename)
    #   expect(File).not_to exist(filename)
    #   MercatorIcecat::Access.download_index(full: true)
    #   expect(File).to exist(filename)
    # end
  end


  describe "product" do
    it "downloads xml five fore product", focus: true do
      @product = create(:product, number: "HP-D5T59EA")
      MercatorIcecat::Access.product(product_id: @product.id)
    end
  end


  describe "product_url", focus: true do
    it "returns the product url" do
      @metadatum = create(:metadatum)
      expect(MercatorIcecat::Access.product_url(product_id: @metadatum.product_id)).to eql "test"
    end
  end
end