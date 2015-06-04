require 'spec_helper'

describe Productmanager::FrontController, :type => :controller do
  describe "before_filters" do
    before :each do
      act_as_user
    end

    it "should check for productmanager_required" do
      no_redirects
      expect(controller).to receive(:productmanager_required)
      get :index
    end

    it "redirects to user login path unless user is administrator" do
      get :index
      expect(response).to redirect_to(:user_login)
    end
  end


  context "actions" do
    before :each do
      no_redirects && act_as_productmanager
    end


    describe "index" do
      before :each do
        @product = create(:product)
        @category = create(:category)
        create(:categorization, product_id: @product.id,
                                category_id: @category.id)
      end

      it "reads the category if product in params" do
        get :index, product_id: @product.id
        expect(assigns(:selected_category)).to eql @category
      end

      it "reads the product if product in params" do
        get :index, product_id: @product.id
        expect(assigns(:selected_product)).to eql @product
      end

      it "reads the categery if category in params" do
        get :index, category_id: @category.id
        expect(assigns(:selected_category)).to eql @category
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


    describe "GET #manage_products" do
      context "updating stati" do
        before :each do
          @active_product = create(:product)
          @new_product = create(:new_product)

          @category = create(:category)
          create(:categorization, product_id: @active_product.id,
                                  category_id: @category.id)
          create(:categorization, product_id: @new_product.id,
                                  category_id: @category.id)

          # We merge the id param in here ....
          @params = { id: @category.id,
                      cmd: "save-records",
                      changes: { "0" => { recid: @new_product.id.to_s,
                                          state: { id: "active",
                                                   text: "aktiv" }},
                                 "1" => { recid: @active_product.id.to_s,
                                          state: { id: "deprecated",
                                                   text: "inaktiv" }}}}
        end

        it "changes the states for both products" do
          get :manage_products, @params
          @active_product.reload
          @new_product.reload
          expect(@active_product.state).to eql "deprecated"
          expect(@new_product.state).to eql "active"
        end

        it "reads the category" do
          get :manage_products, @params
          expect(assigns(:category)).to eql @category
        end

        it "reads the products" do
          get :manage_products, @params
          expect(assigns(:products)).to match_array @category.products.to_a
        end

        it "returns the correct json" do
          get :manage_products, @params
          expect(response.body).to be_json_eql( {records: [{ description_de: "Deutsch: Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ullam, aliquid.",
                                                             description_en: "English: Lorem ipsum dolor sit amet, consectetur adipisicing elit. Similique, repellat!",
                                                             long_description_de: "Deutsch: Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ullam, aliquid.",
                                                             long_description_en: "English: Lorem ipsum dolor sit amet, consectetur adipisicing elit. Similique, repellat!",
                                                             number: "new_product",
                                                             recid: @new_product.id,
                                                             state: ["active"],
                                                             title_de: "default product",
                                                             title_en: "Article One Two Three",
                                                             warranty_de: "Ein Jahr mit gewissen Einschränkungen",
                                                             warranty_en: "One year with evereal restrictions"},
                                                           { description_de: "Deutsch: Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ullam, aliquid.",
                                                             description_en: "English: Lorem ipsum dolor sit amet, consectetur adipisicing elit. Similique, repellat!",
                                                             long_description_de: "Deutsch: Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ullam, aliquid.",
                                                             long_description_en: "English: Lorem ipsum dolor sit amet, consectetur adipisicing elit. Similique, repellat!",
                                                             number: "123",
                                                             recid: @active_product.id,
                                                             state: [ "inactive" ],
                                                             title_de: "default product",
                                                             title_en: "Article One Two Three",
                                                             warranty_de: "Ein Jahr mit gewissen Einschränkungen",
                                                             warranty_en: "One year with evereal restrictions"} ],
                                                 status: "success",
                                                 total: 2 }.to_json)
        end
      end


      context "reading products" do
        before :each do
          @active_product = create(:product)
          @new_product = create(:new_product)

          @category = create(:category)
          create(:categorization, product_id: @active_product.id,
                                  category_id: @category.id)
          create(:categorization, product_id: @new_product.id,
                                  category_id: @category.id)

        end

        it "reads the category" do
          get :manage_products, id: @category.id, cmd: "get-records"
          expect(assigns(:category)).to eql @category
        end

        it "reads the products" do
          get :manage_products, id: @category.id, cmd: "get-records"
          expect(assigns(:products)).to match_array @category.products.to_a
        end

        it "returns the correct json" do
          get :manage_products, id: @category.id, cmd: "get-records"
          expect(response.body).to be_json_eql( {records: [{ description_de: "Deutsch: Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ullam, aliquid.",
                                                             description_en: "English: Lorem ipsum dolor sit amet, consectetur adipisicing elit. Similique, repellat!",
                                                             long_description_de: "Deutsch: Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ullam, aliquid.",
                                                             long_description_en: "English: Lorem ipsum dolor sit amet, consectetur adipisicing elit. Similique, repellat!",
                                                             number: "new_product",
                                                             recid: @new_product.id,
                                                             state: ["new"],
                                                             title_de: "default product",
                                                             title_en: "Article One Two Three",
                                                             warranty_de: "Ein Jahr mit gewissen Einschränkungen",
                                                             warranty_en: "One year with evereal restrictions"},
                                                           { description_de: "Deutsch: Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ullam, aliquid.",
                                                             description_en: "English: Lorem ipsum dolor sit amet, consectetur adipisicing elit. Similique, repellat!",
                                                             long_description_de: "Deutsch: Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ullam, aliquid.",
                                                             long_description_en: "English: Lorem ipsum dolor sit amet, consectetur adipisicing elit. Similique, repellat!",
                                                             number: "123",
                                                             recid: @active_product.id,
                                                             state: [ "active" ],
                                                             title_de: "default product",
                                                             title_en: "Article One Two Three",
                                                             warranty_de: "Ein Jahr mit gewissen Einschränkungen",
                                                             warranty_en: "One year with evereal restrictions"} ],
                                                 status: "success",
                                                 total: 2 }.to_json)
        end
      end
    end


    # get    'front/manage_products/:id'   => 'front#manage_products'
    # post   'front/manage_category/:id'   => 'front#manage_category'
    # post   'front/update_categories'     => 'front#update_categories'
    # delete 'front/category/:id'          => 'front#delete_category'
    # post   'front/update_categorization' => 'front#update_categorization'

    # childrenarray is tested inherently by show_categorytree
  end
end