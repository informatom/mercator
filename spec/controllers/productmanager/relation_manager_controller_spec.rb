require 'spec_helper'

describe Productmanager::RelationManagerController, :type => :controller do
  context "actions" do
    before :each do
      no_redirects && act_as_productmanager
    end


    describe "index" do
      it "finds a product by product id" do
        @product = create(:product)
        get :index, id: @product.id
        expect(assigns(:product)).to eql @product
      end
    end


    describe "GET #show_products" do
      before :each do
        @product = create(:product)
        @second_product = create(:second_product)
      end

      it "reads the products" do
        get :show_products
        expect(assigns(:products)).to match_array [@product, @second_product]
      end

      it "returns the correct json" do
        get :show_products
        expect(response.body).to be_json_eql({ records: [{ number: "123",
                                                           recid: @product.id,
                                                           state: ["active"],
                                                           title_de: "default product",
                                                           title_en: "Article One Two Three" },
                                                         { number: "42",
                                                           recid: @second_product.id,
                                                           state: ["active"],
                                                           title_de: "Artikel Zwei",
                                                           title_en: "Article Two" } ],
                                               status: "success",
                                               total: 2 }.to_json)
      end
    end


    describe "GET #show_productrelations" do
      before :each do
        @product = create(:product)
        @second_product = create(:second_product)
        @third_product = create(:third_product)
        @first_product_relation = create(:productrelation, product_id: @product.id,
                                                           related_product_id: @second_product.id)
        @second_product_relation = create(:productrelation, product_id: @product.id,
                                                            related_product_id: @third_product.id)
      end

      it "reads the products" do
        get :show_productrelations, id: @product.id
        expect(assigns(:productrelations)).to match_array [@first_product_relation,
                                                           @second_product_relation]
      end

      it "returns the correct json" do
        get :show_productrelations, id: @product.id
        expect(response.body).to be_json_eql({ records: [ { recid: @first_product_relation.id,
                                                            related_product_number: "42" },
                                                          { recid: @second_product_relation.id,
                                                            related_product_number: "number 3" } ],
                                               status: "success",
                                               total: 2 }.to_json)
      end
    end


    describe "POST #create_productrelation" do
      before :each do
        @product = create(:product)
        @second_product = create(:second_product)
      end

      it "creates a productrelation" do
        post :create_productrelation, product_id: @product,
                                      related_product_id: @second_product
        expect(assigns(:productrelation)).to be_a Productrelation
      end

      it "has the right partners" do
        post :create_productrelation, product_id: @product,
                                      related_product_id: @second_product
        expect(assigns(:productrelation).product_id).to eql @product.id
        expect(assigns(:productrelation).related_product_id).to eql @second_product.id
      end

      it "renders nothing" do
        post :create_productrelation, product_id: @product,
                                      related_product_id: @second_product
        expect(response.body).to eql("")
      end
    end


    describe "DELETE #delete_productrelation" do
      before :each do
        @product = create(:product)
        @second_product = create(:second_product)
        @product_relation = create(:productrelation, product_id: @product.id,
                                                     related_product_id: @second_product.id)
      end

      it "finds the productrelation" do
        delete :delete_productrelation, id: @product_relation.id
        expect(assigns(:productrelation)).to eql @product_relation
      end

      it "deletes the productrelation" do
        delete :delete_productrelation, id: @product_relation.id
        expect(Productrelation.where(id: @product_relation.id)).to be_empty
      end

      it "renders nothing" do
        delete :delete_productrelation, id: @product_relation.id
        expect(response.body).to eql("")
      end
    end


    describe "GET #show_supplyrelations" do
      before :each do
        @product = create(:product)
        @second_product = create(:second_product)
        @third_product = create(:third_product)
        @first_supply_relation = create(:supplyrelation, product_id: @product.id,
                                                         supply_id: @second_product.id)
        @second_supply_relation = create(:supplyrelation, product_id: @product.id,
                                                          supply_id: @third_product.id)
      end

      it "reads the products" do
        get :show_supplyrelations, id: @product.id
        expect(assigns(:supplyrelations)).to match_array [@first_supply_relation,
                                                           @second_supply_relation]
      end

      it "returns the correct json" do
        get :show_supplyrelations, id: @product.id
        expect(response.body).to be_json_eql({ records: [ { recid: @first_supply_relation.id,
                                                            supply_number: "42" },
                                                          { recid: @second_supply_relation.id,
                                                            supply_number: "number 3" } ],
                                               status: "success",
                                               total: 2 }.to_json)
      end
    end


    describe "POST #create_productrelation" do
      before :each do
        @product = create(:product)
        @second_product = create(:second_product)
      end

      it "creates a supplyrelation" do
        post :create_supplyrelation, product_id: @product,
                                     supply_id: @second_product
        expect(assigns(:supplyrelation)).to be_a Supplyrelation
      end

      it "has the right partners" do
        post :create_supplyrelation, product_id: @product,
                                     supply_id: @second_product
        expect(assigns(:supplyrelation).product_id).to eql @product.id
        expect(assigns(:supplyrelation).supply_id).to eql @second_product.id
      end

      it "renders nothing" do
        post :create_supplyrelation, product_id: @product,
                                     supply_id: @second_product
        expect(response.body).to eql("")
      end
    end


    describe "DELETE #delete_supplyrelation" do
      before :each do
        @product = create(:product)
        @second_product = create(:second_product)
        @supply_relation = create(:supplyrelation, product_id: @product.id,
                                                    supply_id: @second_product.id)
      end

      it "finds the supplyrelation" do
        delete :delete_supplyrelation, id: @supply_relation.id
        expect(assigns(:supplyrelation)).to eql @supply_relation
      end

      it "deletes the supplyrelation" do
        delete :delete_supplyrelation, id: @supply_relation.id
        expect(Supplyrelation.where(id: @supply_relation.id)).to be_empty
      end

      it "renders nothing" do
        delete :delete_supplyrelation, id: @supply_relation.id
        expect(response.body).to eql("")
      end
    end


    describe "GET #manage_recommendations" do
      before :each do
        @product = create(:product)
        @second_product = create(:second_product)
        @third_product = create(:third_product)
        @first_recommendation = create(:recommendation, product_id: @product.id,
                                                        recommended_product_id: @second_product.id,
                                                        reason_de: "Grund",
                                                        reason_en: "Reason")
        @second_recommendation = create(:recommendation, product_id: @product.id,
                                                         recommended_product_id: @third_product.id,
                                                         reason_de: "Grund",
                                                         reason_en: "Reason")
      end
      # creating records is handled in create_recommendation
      context "editing records" do
        before :each do
          @params = { cmd: "save-records",
                      changes: { "0" => { recid: @first_recommendation.id.to_s,
                                          reason_de: "geänderter Grund",
                                          reason_en: "changed reason"},
                                 "1" => { recid: @second_recommendation.id.to_s,
                                          reason_en: "another changed reason",
                                          reason_de: "noch ein geänderter Grund"}},
                      id: @product.id.to_s}
        end

        it "performs the changes" do
          get :manage_recommendations, @params
          @first_recommendation.reload
          @second_recommendation.reload
          expect(@first_recommendation.reason_de).to eql "geänderter Grund"
          expect(@first_recommendation.reason_en).to eql "changed reason"
          expect(@second_recommendation.reason_de).to eql "noch ein geänderter Grund"
          expect(@second_recommendation.reason_en).to eql "another changed reason"
        end

        it "reads the recommendations for the product" do
          get :manage_recommendations, @params
          expect(assigns(:recommendations)).to match_array [@first_recommendation, @second_recommendation]
        end

        it "returns the correct json" do
          get :manage_recommendations, @params
          expect(response.body).to be_json_eql({ records: [{ reason_de: "geänderter Grund",
                                                             reason_en: "changed reason",
                                                             recid: @first_recommendation.id,
                                                             supply_number: "42" },
                                                           { reason_de: "noch ein geänderter Grund",
                                                             reason_en: "another changed reason",
                                                             recid: @second_recommendation.id,
                                                             supply_number: "number 3" } ],
                                                 status: "success",
                                                 total: 2 }.to_json)
        end
      end

      context "reading records" do
        before :each do
          @params = { cmd: "get-records",
                      id: @product.id.to_s }
        end

        it "reads the recommendations for the product" do
          get :manage_recommendations, @params
          expect(assigns(:recommendations)).to match_array [@first_recommendation, @second_recommendation]
        end

        it "returns the correct json" do
          get :manage_recommendations, @params
          expect(response.body).to be_json_eql({ records: [{ reason_de: "Grund",
                                                             reason_en: "Reason",
                                                             recid: @first_recommendation.id,
                                                             supply_number: "42" },
                                                           { reason_de: "Grund",
                                                             reason_en: "Reason",
                                                             recid: @second_recommendation.id,
                                                             supply_number: "number 3" } ],
                                                 status: "success",
                                                 total: 2 }.to_json)
        end
      end
    end


    describe "POST #create_recommendation" do
      before :each do
        @product = create(:product)
        @second_product = create(:second_product)
        @params = { cmd: "save-record",
                    recid: "0",
                    record: { reason_de: "ein Grund",
                              reason_en: "a reason",
                              product_id: @product.id.to_s,
                              recommended_product_id: @second_product.id }}
      end

      it "checks if the recommendation already exists" do
        create(:recommendation,  product_id: @product.id,
                                 recommended_product_id: @second_product.id,
                                 reason_de: "Grund",
                                 reason_en: "Reason")
        post :create_recommendation, @params
        expect(response.body).to be_json_eql({ status: "error",
                                               message: I18n.t("mercator.recommendation_exists") }.to_json)
      end

      it "creates a recommendation with the correct attributes" do
        post :create_recommendation, @params
        expect(assigns(:recommendation).product_id).to eql @product.id
        expect(assigns(:recommendation).recommended_product_id).to eql @second_product.id
        expect(assigns(:recommendation).reason_de).to eql "ein Grund"
        expect(assigns(:recommendation).reason_en).to eql "a reason"
      end

      it "renders success" do
        post :create_recommendation, @params
        expect(response.body).to be_json_eql({ status: "success" }.to_json)
      end
    end


    describe "DELETE #delete_recommendation" do
      before :each do
        @product = create(:product)
        @second_product = create(:second_product)
        @recommendation = create(:recommendation, product_id: @product.id,
                                                  recommended_product_id: @second_product.id)
      end

      it "finds the recommendation" do
        delete :delete_recommendation, id: @recommendation.id
        expect(assigns(:recommendation)).to eql @recommendation
      end

      it "deletes the recommendation" do
        delete :delete_recommendation, id: @recommendation.id
        expect(Recommendation.where(id: @recommendation.id)).to be_empty
      end

      it "renders nothing" do
        delete :delete_recommendation, id: @recommendation.id
        expect(response.body).to eql("")
      end
    end


    describe "GET #show_categorizations" do
      before :each do
        @product = create(:product)
        @first_category = create(:category)
        @second_category = create(:category, name_de: "zweite Kategorie")
        @first_categorization = create(:categorization, product_id: @product.id,
                                                        category_id: @first_category.id,
                                                        position: 10)
        @second_categorization = create(:categorization, product_id: @product.id,
                                                         category_id: @second_category.id,
                                                         position: 20)
      end

      it "finds the categorizations" do
        get :show_categorizations, id: @product.id
        expect(assigns(:categorizations)).to match_array [ @first_categorization,
                                                           @second_categorization ]
      end

      it "renders the correct json" do
        get :show_categorizations, id: @product.id
      end
    end


    describe "get #show_categorytree" do
      it "returns category tree" do
        @grandparent = create(:category)
        @parent = create(:category, parent: @grandparent)
        @category = create(:category, parent: @parent)

        get :show_categorytree
        expect(response.body).to be_json_eql([{children: [{ children: [{ folder: false,
                                                                         key: @category.id,
                                                                         title: "Printer" } ],
                                                            folder: false,
                                                            key: @parent.id,
                                                            title: "Printer"} ],
                                               folder: false,
                                               key: @grandparent.id,
                                               title: "Printer"} ] .to_json)
      end
    end


    describe "POST #add_categorization" do
      before :each do
        @product = create(:product)
        @category = create(:category)
      end

      it "checks if the categorization already exists" do
        create(:categorization,  product_id: @product.id,
                                 category_id: @category.id,
                                 position: 10)
        post :add_categorization, category_id: @category.id, product_id: @product.id
        expect(response.body).to be_json_eql({ status: "error",
                                               message: I18n.t("mercator.relation_manager.categorization_exists") }.to_json)
      end

      it "creates a categorization with the correct attributes" do
        post :add_categorization, category_id: @category.id, product_id: @product.id
        expect(assigns(:categorization).product_id).to eql @product.id
        expect(assigns(:categorization).category_id).to eql @category.id
        expect(assigns(:categorization).position).to eql 1
      end

      it "renders success" do
        post :add_categorization, category_id: @category.id, product_id: @product.id
        expect(response.body).to eql("")
      end
    end


    describe "DELETE #delete_categorization" do
      before :each do
        @product = create(:product)
        @category = create(:category)
        @categorization = create(:categorization,  product_id: @product.id,
                                                   category_id: @category.id,
                                                   position: 10)
      end

      it "finds the recommendation" do
        delete :delete_categorization, id: @categorization.id
        expect(assigns(:categorization)).to eql @categorization
      end

      it "deletes the recommendation" do
        delete :delete_categorization, id: @categorization.id
        expect(Categorization.where(id: @categorization.id)).to be_empty
      end

      it "renders nothing" do
        delete :delete_categorization, id: @categorization.id
        expect(response.body).to eql("")
      end
    end

    # childrenarray is tested inherently by show_categorytree
  end
end