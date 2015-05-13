require 'spec_helper'

describe Product do
  it "is valid with title_de, title_en, number, description_de, description_en,
      long_description_de, long_description_en, warranty_de, warranty_en,
      document, photo" do
    expect(build :product).to be_valid
  end

  it {should validate_presence_of :title_de}
  it {should validate_presence_of :number}
  it {should validate_uniqueness_of :number}

  it {should have_many :property_groups}
  it {should have_many :properties}
  it {should have_many :values}

  it {should have_many :categories}
  it {should have_many :categorizations}

  it {should have_many :related_products}
  it {should have_many :productrelations}

  it {should have_many :recommended_products}
  it {should have_many :recommendations}

  it {should have_many :supplies}
  it {should have_many :supplyrelations}

  it {should have_many :inventories}
  it {should have_many :prices}

  it {should have_many :features}

  it "is versioned" do
    is_expected.to respond_to :versions
  end

  it "has a document attached" do
    is_expected.to respond_to :document
  end
  it "has a photo attached" do
    is_expected.to respond_to :photo
  end

  #--- Class Methods --- #

  context "find_by_name" do
    it "can be found by name" do
      expect(Product).to respond_to(:find_by_name)
    end
  end

  context "with_at_least_x_prices" do
    it "finds products with two prices" do
      @inventory_with_two_prices = create(:inventory_with_two_prices)
      expect(Product.with_at_least_x_prices(2)).to eql [@inventory_with_two_prices.product]
    end
  end

  context "diffs_of_double_priced" do
    it "outputs the diffs" do
      @inventory_with_two_prices = create(:inventory_with_two_prices)
      expect(Product.diffs_of_double_priced).to eql [@inventory_with_two_prices.product]
    end
  end

  context "activate_all" do
    it "activates new products" do
      User.send(:remove_const, :JOBUSER) # just to avoid warning in the next line
      User::JOBUSER = create(:jobuser)
      create(:new_product)
      expect{Product.activate_all}.to change{Product.active.count}.by(1)
    end
  end
end