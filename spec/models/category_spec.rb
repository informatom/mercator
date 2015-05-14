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

  context "try_deprecation" do
    before :each do
      User.send(:remove_const, :JOBUSER) # just to avoid warning in the next line
      User::JOBUSER = create(:jobuser)
    end

    it "deprecates active category without active product" do
      @category = create(:category, state: "active")
      expect{@category.try_deprecation}.to change{Category.deprecated.count}.by(1)
    end

    it "does not deprecate new category without active product" do
      @category = create(:category, state: "new" )
      expect{@category.try_deprecation}.not_to change{Category.deprecated.count}
    end


    it 'does not deprecate active category with product' do
      @category = create(:category, state: "active")
      @product = create(:product, state: "active")
      create(:categorization, category: @category, product: @product)
      expect{@category.try_deprecation}.not_to change{Category.deprecated.count}
    end
  end


  context "try_reactivation" do
    before :each do
      User.send(:remove_const, :JOBUSER) # just to avoid warning in the next line
      User::JOBUSER = create(:jobuser)
    end

    it "reactivates category with active product" do
      @category = create(:category, state: "deprecated")
      @product = create(:product, state: "active")
      create(:categorization, category: @category, product: @product)
      expect{@category.try_reactivation}.to change{Category.active.count}.by(1)
    end

    it "does not reactivate deprecated category without product" do
      @category = create(:category, state: "deprecated")
      expect{@category.try_reactivation}.not_to change{Category.active.count}
    end
  end


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
    it "trys to deprecate each category" do
      expect_any_instance_of(Category).to receive(:try_deprecation)
      create(:category)
      Category.deprecate
    end
  end


  context "reactivate" do
    it "calls try_reactivation fo each category" do
      expect_any_instance_of(Category).to receive(:try_reactivation)
      create(:category)
      Category.reactivate
    end
  end


  context "update_property_hash" do
    it "calls update_property_hash fo each category" do
      expect_any_instance_of(Category).to receive(:update_property_hash)
      create(:category)
      Category.update_property_hash
    end
  end


  context "reindexing_and_filter_updates" do
    before :each do
      @category = create(:category)
      create(:dummy_customer)
    end

    it "reindexes Category class" do
      expect(Category).to receive(:reindex)
      Category.reindexing_and_filter_updates
    end

    it "calls reindex fo each category" do
      expect_any_instance_of(Category).to receive(:update_property_hash)
      Category.reindexing_and_filter_updates
    end

    it "calls update_property_hash fo each category" do
      expect_any_instance_of(Category).to receive(:update_property_hash)
      Category.reindexing_and_filter_updates
    end

    it "sets default value 0 for filtermin if no`prices given" do
      Category.reindexing_and_filter_updates
      expect(@category.filtermin.to_i).to eql(42)
    end

    it "sets default value 1000 filtermax if no`prices given" do
      Category.reindexing_and_filter_updates
      expect(@category.filtermax.to_i).to eql(4242)
    end


    context "prices are given" do
      before :each do
        @product = create(:product_with_inventory_and_two_prices)
        create(:categorization, category: @category, product: @product)
        @second_product = create(:product_with_inventory_and_lower_price)
        create(:categorization, category: @category, product: @second_product)
      end

      it "sets filtermin correctly" do
        Category.reindexing_and_filter_updates
        @category.reload
        expect(@category.filtermin).to eql(38)
      end

      it "sets filtermax correctly" do
        Category.reindexing_and_filter_updates
        @category.reload
        expect(@category.filtermax).to eql(43)
      end
    end
  end
end