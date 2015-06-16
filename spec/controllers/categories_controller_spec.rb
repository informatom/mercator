require 'spec_helper'

describe CategoriesController, :type => :controller do

  describe "crud actions" do
    before :each do
      no_redirects and act_as_user
      @category = create(:category, filtermin: 10,
                                    filtermax: 100)
    end


    describe "GET #show" do
      before :each do
        create(:dummy_customer)

        @filterable_property = create(:property, state: "filterable")
        @unfilterable_property = create(:property, state: "unfilterable")
        @product = create(:product_with_inventory_and_lower_price)

        create(:categorization, product_id: @product.id,
                                category_id: @category.id)
        create(:value, property_id: @filterable_property.id,
                       product_id: @product.id,
                       state: "textual",
                       amount: nil,
                       flag: nil)
        create(:value, property_id: @unfilterable_property.id,
                       product_id: @product.id,
                       state: "textual",
                       amount: nil,
                       flag: nil)

        @filtered_product = create(:product_with_inventory_and_two_prices, number: "seached product")
        create(:categorization, product_id: @filtered_product.id,
                                category_id: @category.id)
        @filtered_value = create(:value, property_id: @filterable_property.id,
                                         product_id: @filtered_product.id,
                                         state: "textual",
                                         amount: nil,
                                         flag: nil,
                                         title_en: "searched Value")


        @category.update_property_hash # calculates filters
        Product.reindex
        Category.reindex
      end

      it "finds the right category" do
        get :show, id: @category.id
        expect(assigns(:category)).to eql @category
      end

      it "assigns min" do
        get :show, id: @category.id
        expect(assigns(:min)).to eql 10
      end

      it "assigns max" do
        get :show, id: @category.id
        expect(assigns(:max)).to eql 101
      end

      it "assigns products" do
        get :show, id: @category.id
        expect(assigns(:products)).to match_array [@product, @filtered_product]
      end


      context "filter set" do
        it "assigns filter" do
          get :show, id: @category.id, filter: { "property" => "searched Value kg" }
          expect(assigns(:filter)).to eql({ "property" => "searched Value kg" })
        end

        it  "assigns facets" do
          get :show, id: @category.id, filter: { "property" => "searched Value kg" }
          expect(assigns(:facets)).to match_array [@filtered_product]
        end

        it "filters products" do
          get :show, id: @category.id, filter: { "property" => "searched Value kg" }
          expect(assigns(:products)).to match_array [@filtered_product]
        end
      end


      context "params pricelow and pricehigh set" do
        it "assigns minslider" do
         get :show, id: @category.id, pricelow: 20,
                                      pricehigh: 40
         expect(assigns(:minslider)).to eql 20
        end

        it "assigns maxslider" do
         get :show, id: @category.id, pricelow: 20,
                                      pricehigh: 40
         expect(assigns(:maxslider)).to eql 41
        end

        it  "assigns facets" do
          get :show, id: @category.id, pricelow: 20,
                                       pricehigh: 40
          expect(assigns(:facets)).to match_array [@product]
        end

        it "filters products #1" do
          get :show, id: @category.id, pricelow: 20,
                                       pricehigh: 40
          expect(assigns(:products)).to match_array [@product]
        end

        it "filters products #2" do
          get :show, id: @category.id, pricelow: 40,
                                       pricehigh: 50,
                                       filter: { "property" => "searched Value kg" }
          expect(assigns(:products)).to match_array [@filtered_product]
        end

        it "filters products #3" do
          get :show, id: @category.id, pricelow: 20,
                                       pricehigh: 40,
                                       filter: { "property" => "searched Value kg" }
          expect(assigns(:products)).to match_array []
        end
      end


      context "params pricelow and pricehigh not set" do
        it "assigns minslider" do
         get :show, id: @category.id
         expect(assigns(:minslider)).to eql 10
        end

        it "assigns maxslider" do
         get :show, id: @category.id
         expect(assigns(:maxslider)).to eql 101
        end
      end
    end


    describe "GET #index" do
      it "assigns root categories" do

        @subcategory = create(:category, parent_id: @category)
        get :index
        expect(assigns(:categories)).to match_array [@category]
      end
    end


    describe "POST #refresh" do
      it "assigns the category" do
        @product = create(:product)
        xhr :post, :refresh, id: @product.id,
                             page_path: "/path/#{@category.id}-text",
                             render: "whatever"
        expect(assigns(:category)).to eql @category
      end

      it "assigns inventory, when given" do
        @product = create(:product_with_inventory)
        xhr :post, :refresh, id: @product.id,
                             inventory_id: @product.inventories.first.id,
                             page_path: "/path/#{@category.id}-text",
                             render: "whatever"
        expect(assigns(:inventory)).to eql @product.inventories.first
      end
    end
  end
end