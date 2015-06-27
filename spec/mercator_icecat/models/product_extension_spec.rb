require 'spec_helper'

describe Product do
  before :each do
    @product = create(:product, alternative_number: "D9190B")
    @metadatum = create(:metadatum, product_id: @product.id)
  end


  # --- Class Methods --- #

  it "has many icecat_metadata" do
    it {should have_many :icecat_metadata}
  end


  it "has a scope without_icecat_metadata" do
    @product_without_icecat = create(:second_product)
    expect(Product.without_icecat_metadata).to match_array [@product_without_icecat]
  end


  describe "update_from_icecat" do
    it "updates from icecat for each product", focus:true  do
      expect_any_instance_of(Product).to receive(:update_from_icecat)
      Product.update_from_icecat
    end
  end


  # --- Instance Methods --- #


  describe "icecat_article_number" do
    it "cuts of 'HP-'" do
      @product.update(number: "HP-some_number",
                      alternative_number: nil)
      expect(@product.icecat_article_number).to eql "some_number"
    end

    it "returns alternative number, if present" do
      expect(@product.icecat_article_number).to eql "D9190B"
    end

    it "leaves non HP-numbers untouched" do
      @product.update(alternative_number: nil)
      expect(@product.icecat_article_number).to eql "123"
    end
  end


  describe "icecat_vendor" do
    it "returns 1 for HP" do
      @product.update(number: "HP-some_number",
                      alternative_number: nil)
      expect(@product.icecat_vendor).to eql "1"
    end

    it "returns 1 for HP" do
      @product.update(number: "some_number",
                      alternative_number: "HP-some_number")
      expect(@product.icecat_vendor).to eql "1"
    end

    it "returns nil otherwise" do
      @product.update(alternative_number: nil)
      expect(@product.icecat_vendor).to eql nil
    end
  end


  describe "icecat_product_id" do
    it "returns the icecat_product_id" do
      expect(@product.icecat_product_id).to eql "1286"
    end
  end


  describe "update_from_icecat" do
    it "returns nil, if no metadatum found" do
      @product_without_icecat = create(:second_product)
      expect(@product_without_icecat.update_from_icecat(from_today: false)).to eql nil
    end

    it "returns nil, if asked for current updates and update is older" do
      @metadatum.update(updated_at: Time.now - 1.month)
      expect(@product.update_from_icecat(from_today: true)).to eql nil
    end

    it "finds the metadatum" do
      @product.update_from_icecat(from_today: false)
      expect(@product.instance_variable_get(:@metadatum)).to eql @metadatum
    end

    it "downloads the file" do
      expect_any_instance_of(MercatorIcecat::Metadatum).to receive(:download)
      @product.update_from_icecat(from_today: false)
    end

    it "updates the product" do
      expect_any_instance_of(MercatorIcecat::Metadatum).to receive(:update_product)
      @product.update_from_icecat(from_today: false)
    end

    it "updates the product relations" do
      expect_any_instance_of(MercatorIcecat::Metadatum).to receive(:update_product_relations)
      @product.update_from_icecat(from_today: false)
    end

    it "imports missing images" do
      @product.update(photo_file_name: nil)
      expect_any_instance_of(MercatorIcecat::Metadatum).to receive(:import_missing_image)
      @product.update_from_icecat(from_today: false)
    end

    it "returns true" do
      expect(@product.update_from_icecat(from_today: false)).to eql true
    end
  end
end