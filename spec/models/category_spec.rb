require 'spec_helper'

describe Category do
  it "is valid with name_de, name_en, description_de, description_en, long_description_de," +
     "long_description_en, ancestry, position, legacy_id, filters, filtermin, filtermax," +
     "erp_identifier, usage, squeel_condition, photo, document" do
    expect(build :category).to be_valid
  end

  it {should validate_presence_of :name_de}
  it {should validate_presence_of :name_en}

  it {should validate_numericality_of(:position).only_integer}
  it {should validate_presence_of :position}

  it {should have_many :products}
  it {should have_many :categorizations}

  it {should have_many :values}
  it {should have_many :properties}

  it "is in a tree structure" do
    is_expected.to respond_to :parent
    is_expected.to respond_to :children
  end

  it "has a document attached" do
    is_expected.to respond_to :document
  end
  it "has a photo attached" do
    is_expected.to respond_to :photo
  end

  it "is versioned" do
    is_expected.to respond_to :versions
  end


  #--- Instance Methods ---#

  context "search data" do
    it "returns search date hash" do
      @category = create(:category)
      expected_result = {:name => "Drucker",
                         :name_de => "Drucker",
                         :name_en => "Printer",
                         :description => "Tolle Drucker",
                         :description_de => "Tolle Drucker",
                         :description_en => "Fantastic Printers",
                         :long_description => "In der Tat tolle Drucker",
                         :long_description_de => "In der Tat tolle Drucker",
                         :long_description_en => "Fantastic Printers, indeed.",
                         :state => "active"}
      expect(@category.search_data).to eql(expected_result)
    end
  end


  #--- Class Methods --- #

  context "find_by_name" do
    it "can be found by name" do
      expect(Category).to respond_to(:find_by_name)
    end
  end

  context "mercator do" do
    it "returns the mercator category" do
      expect(Category.mercator.usage).to eql("mercator")
    end
  end

  context "auto do" do
    it "returns the auto category" do
      expect(Category.auto.usage).to eql("auto")
    end
  end

  context "novelties do" do
    it "returns the novelties category" do
      expect(Category.novelties.usage).to eql("squeel")
    end
  end

  context "topseller do" do
    it "returns the topseller category" do
      expect(Category.topseller.usage).to eql("squeel")
    end
  end

  context "orphans do" do
    it "returns the orphans category" do
      expect(Category.orphans.usage).to eql("orphans")
    end
  end

  context "deprecate" do
    it "deprecates active category without active product" do
      @category = create(:category, state: "active")
      @new_category = create(:category, state: "new_active",
                                        name_de: "Neue Kategorie")
      @category_with_product = create(:category, name_de: "Kategorie mit Produkt")
      @product = create(:product, state: "active")
      create(:categorization, category: @category_with_product, product: @product)

      User.send(:remove_const, :JOBUSER) # just to avoid warning in the next line
      User::JOBUSER = create(:jobuser)

      expect{Category.deprecate}.to change{Category.deprecated.count}.by(1)
    end
  end

  context "reactivate" do
    it "reactivates category with active product" do
      @category = create(:category, state: "deprecated")
      @category_with_product = create(:category, name_de: "Kategorie mit Produkt",
                                                 state: "deprecated")
      @product = create(:product, state: "active")
      create(:categorization, category: @category_with_product, product: @product)

      User.send(:remove_const, :JOBUSER) # just to avoid warning in the next line
      User::JOBUSER = create(:jobuser)

      expect{Category.reactivate}.to change{Category.active.count}.by(1)
    end
  end
end