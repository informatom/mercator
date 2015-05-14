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


  #--- Instance Methods --- #


  context "determine_price" do
    before :each do
      @user = create(:user)
      @product = create(:product_with_inventory_and_two_prices)
    end

    it "determines the price for user" do
      expect(@product.determine_price(customer_id: @user.id)).to eql(42)
    end

    it "determines the price incl_vat for user" do
      expect(@product.determine_price(customer_id: @user.id,
                                      incl_vat: true)).to eql(50.4)
    end

    it "determines the reduced price for user" do
      expect(@product.determine_price(customer_id: @user.id,
                                      amount: 7)).to eql(38)
    end
  end


  context "delivery_time" do
    it "returns delivery time if inventory present" do
      @product = create(:product_with_inventory)
      expect(@product.delivery_time).to eql("2 Wochen")
    end

    it "returns standard delivery time if no inventory present" do
      @product = create(:product)
      expect(@product.delivery_time).to eql("On request")
    end
  end


  context "values" do
    before :each do
      @product = create(:product)
      @property_group = create(:property_group)
      property = create(:property, state: "filterable")
      property_two   = create(:property, name_en: "Property 2",
                                         state: "filterable")
      property_three = create(:property, name_en: "Property 3",
                                         state: "filterable")
      @value = create(:flag_value, product: @product,
                                   property_group: @property_group,
                                   property: property)
      @value_two = create(:numeric_value, product: @product,
                                          property_group: @property_group,
                                          property: property_two)
      @value_three = create(:textual_value, product: @product,
                                            property_group: @property_group,
                                            property: property_three)
    end

    context "tabled_values" do
      it "returns tabled values" do
        expected_result = {"I Am the English Title"=> {"Size"=>"Yes",
                                                       "Property 2"=>"13 kg",
                                                       "Property 3"=>"text value text "}}
        expect(Hash[@product.tabled_values.to_a]).to eql(expected_result)
      end
    end

    context "hashed_values" do
      it "returns hashed values" do
        expected_result = {@property_group.id => [@value, @value_two, @value_three]}
        expect(@product.hashed_values).to eql(expected_result)
      end
    end

    context "search_data" do
      it "returns search data" do
        create(:dummy_customer)
        expected_result = {:title => "default product",
                           :title_de => "default product",
                           :title_en => "Article One Two Three",
                           :number => "123",
                           :description => "Deutsch: Lorem ipsum dolor sit amet, consectetur" +
                                           " adipisicing elit. Ullam, aliquid.",
                           :description_de => "Deutsch: Lorem ipsum dolor sit amet, consectetur" +
                                              " adipisicing elit. Ullam, aliquid.",
                           :description_en => "English: Lorem ipsum dolor sit amet, consectetur" +
                                              " adipisicing elit. Similique, repellat!",
                           :long_description => "Deutsch: Lorem ipsum dolor sit amet, consectetur" +
                                                " adipisicing elit. Ullam, aliquid.",
                           :warranty => "Ein Jahr mit gewissen Einschränkungen",
                           :category_ids => [],
                           :state => "active",
                           :price => nil,
                           "Size" => "Yes",
                           "Property 2" => "13 kg",
                           "Property 3" => "text value text"}
        expect(@product.search_data).to eql(expected_result)
      end
    end

    context "property_hash" do
      it "returns property_hash" do
        expected_result = {"Size"=>"Yes", "Property 2"=>"13 kg", "Property 3"=>"text value text"}
        expect(@product.property_hash).to eql(expected_result)
      end
    end
  end

  context "determine_inventory" do
    before :each do
      @product = create(:product_with_two_inventories)
    end

    it "determines the last inventory for lifo" do
      expect(@product.determine_inventory.created_at.to_date).to eql(Date.today)
    end

    it "determines the first inventory for fifo" do
      create(:constant_fifo)
      expect(@product.determine_inventory.created_at.to_date).to eql(Date.today - 1.day)
    end
  end


  #--- Class Methods --- #

  context "find_by_name" do
    it "can be found by name" do
      expect(Product).to respond_to(:find_by_name)
    end
  end


  context "deprecate" do
    it "deprecated products without inventory" do
      create(:product)
      create(:product_with_inventory)
      User.send(:remove_const, :JOBUSER) # just to avoid warning in the next line
      User::JOBUSER = create(:jobuser)
      expect{Product.deprecate}.to change{Product.active.count}.by(-1)
    end
  end


  context "catch_orphans" do
    it "catogorizes orphaned products in orphan category" do
      create(:product)
      create(:product_in_category)
      expect{Product.catch_orphans}.to change{Category.orphans.categorizations.count}.by(1)
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
      @product = create(:new_product)
      expect{Product.activate_all}.to change{Product.active.count}.by(1)
    end
  end


  context "active_and_number_contains" do
    it "finds active products for certain partrial string of number" do
      create(:product, number: "mynumber", state: "active")
      create(:product, number: "notnumber", state: "active")
      create(:product, number: "notactive", state: "new")
      expect(Product.active_and_number_contains("mynumber").count).to eql(1)
    end
  end
end