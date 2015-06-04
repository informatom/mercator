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


    describe "POST #manage_category" do
      context "creating a new page" do
        before :each do
          @parent = create(:category)

          @params = {cmd: "save-record",
                     recid: "0",
                     record: {position: "12",
                              name_de: "deutscher Titel",
                              name_en: "english Title",
                              description_de: "deutsche Beschreibung",
                              description_en: "english description",
                              long_description_de: "deutsche lange Beschreibung",
                              long_description_en: "english long description",
                              state: {id: "new",
                                      text: "neu"},
                              usage: {id: "standard",
                                      text: "normale Kategorie"},
                              filtermin: "1",
                              filtermax: "100",
                              squeel_condition: "test condition",
                              parent_id: @parent.id.to_s},
                     id: "0"}

          JsonSpec.configure {exclude_keys "created_at", "updated_at"}
        end

        it "creates a new category if save record with recid 0" do
          post :manage_category, @params
          expect(assigns(:category)).to be_a Category
        end

        it "sets the categories attributes" do
          post :manage_category, @params
          expect(assigns(:category).name_de).to eq "deutscher Titel"
          expect(assigns(:category).name_en).to eq "english Title"
          expect(assigns(:category).description_de).to eq "deutsche Beschreibung"
          expect(assigns(:category).description_en).to eq "english description"
          expect(assigns(:category).long_description_de).to eq "deutsche lange Beschreibung"
          expect(assigns(:category).long_description_en).to eq "english long description"
          expect(assigns(:category).state).to eq "new"
          expect(assigns(:category).position).to eq 12
          expect(assigns(:category).filtermin).to eq 1
          expect(assigns(:category).filtermax).to eq 100
          expect(assigns(:category).parent_id).to eq @parent.id
          expect(assigns(:category).squeel_condition).to eq "test condition"
          expect(assigns(:category).usage).to eq "standard"
        end


        it "returns the correct json" do
          post :manage_category, @params
          expect(response.body).to be_json_eql({ record: { description_de: "deutsche Beschreibung",
                                                           description_en: "english description",
                                                           filtermax: "100.0",
                                                           filtermin: "1.0",
                                                           filters: "",
                                                           long_description_de: "deutsche lange Beschreibung",
                                                           long_description_en: "english long description",
                                                           name_de: "deutscher Titel",
                                                           name_en: "english Title",
                                                           parent_id: @parent.id,
                                                           parent_name: "Printer",
                                                           position: 12,
                                                           recid: assigns(:category).id,
                                                           squeel_condition: "test condition",
                                                           state: { id: "new"},
                                                           usage: { id: "standard"} },
                                                 status: "success"} .to_json)
        end
      end


      context "updating a page" do
        before :each do
          @parent = create(:category)
          @category = create(:category, parent_id: @parent.id)
          @another_parent = create(:category)

          @params = { cmd: "save-record",
                      recid:  @category.id.to_s,
                      record: { recid: @category.id.to_s,
                                name_de: "neuer deutscher Titel",
                                name_en: "new english Title",
                                description_de: "neue deutsche Beschreibung",
                                description_en: "new english description",
                                long_description_de: "neue deutsche lange Beschreibung",
                                long_description_en: "new english long description",
                                position: "77",
                                state: { id: "deprecated",
                                         text: "inaktiv"},
                                filtermin: "12",
                                filtermax: "112",
                                parent_id:  @another_parent.id.to_s,
                                usage:  { id: "squeel",
                                          text: "SQueeL"},
                                squeel_condition: "test"},
                                id: @category.id.to_s}
          JsonSpec.configure {exclude_keys "created_at", "updated_at"}
        end

        it "reads the right record" do
          post :manage_category, @params
          expect(assigns(:category)).to eq @category
        end

        it "updates the data" do
          post :manage_category, @params
          expect(assigns(:category).name_de).to eq "neuer deutscher Titel"
          expect(assigns(:category).name_en).to eq "new english Title"
          expect(assigns(:category).description_de).to eq "neue deutsche Beschreibung"
          expect(assigns(:category).description_en).to eq "new english description"
          expect(assigns(:category).long_description_de).to eq "neue deutsche lange Beschreibung"
          expect(assigns(:category).long_description_en).to eq "new english long description"
          expect(assigns(:category).state).to eq "deprecated"
          expect(assigns(:category).position).to eq 77
          expect(assigns(:category).filtermin).to eq 12
          expect(assigns(:category).filtermax).to eq 112
          expect(assigns(:category).parent_id).to eq @another_parent.id
          expect(assigns(:category).squeel_condition).to eq "test"
          expect(assigns(:category).usage).to eq "squeel"
        end

        it "returns the records data" do
          post :manage_category, @params
          expect(response.body).to be_json_eql({record: { description_de:      "neue deutsche Beschreibung",
                                                          description_en:      "new english description",
                                                          filtermax:           "112.0",
                                                          filtermin:           "12.0",
                                                          filters:             "[\"name_de\", \"Drucker\"]",
                                                          long_description_de: "neue deutsche lange Beschreibung",
                                                          long_description_en: "new english long description",
                                                          name_de:             "neuer deutscher Titel",
                                                          name_en:             "new english Title",
                                                          parent_id:           @another_parent.id,
                                                          parent_name:         "Printer",
                                                          position:            77,
                                                          recid:               assigns(:category).id,
                                                          squeel_condition:    "test",
                                                          state:               { id: "deprecated" },
                                                          usage:               { id: "squeel" }},
                                                status: "success"} .to_json)
        end
      end


      context "reading a page" do
        before :each do
          @parent = create(:category)
          @category = create(:category, parent_id: @parent.id)

          @params = { cmd: "get-record",
                      recid:  @category.id.to_s,
                      id: @category.id.to_s}
        end

        it "reads the right record" do
          post :manage_category, @params
          expect(assigns(:category)).to eq @category
        end

        it "returns the records data" do
          post :manage_category, @params
          expect(response.body).to be_json_eql({record: { description_de:      assigns(:category).description_de,
                                                          description_en:      assigns(:category).description_en,
                                                          filtermax:           assigns(:category).filtermax,
                                                          filtermin:           assigns(:category).filtermin,
                                                          filters:             "[\"name_de\", \"Drucker\"]",
                                                          long_description_de: assigns(:category).long_description_de,
                                                          long_description_en: assigns(:category).long_description_en,
                                                          name_de:             assigns(:category).name_de,
                                                          name_en:             assigns(:category).name_en,
                                                          parent_id:           assigns(:category).parent_id,
                                                          parent_name:         assigns(:category).parent.name,
                                                          position:            assigns(:category).position,
                                                          recid:               assigns(:category).id,
                                                          squeel_condition:    assigns(:category).squeel_condition,
                                                          state:               { id: assigns(:category).state },
                                                          usage:               { id: assigns(:category).usage }},
                                                status: "success"}.to_json)
        end
      end
    end


    describe "POST #update_categories" do
      before :each do
        @parent = create(:category)
        @first_category = create(:category, parent: @parent,
                                            position: 0)
        @second_category = create(:category, parent: @parent,
                                             position: 1)

        @categories_param = { "0" => { "key" => "#{@parent.id}", "children" => { "0" => { "key" => "#{@second_category.id}" },
                                                                                 "1" => { "key" => "#{@first_category.id}" }
                                                                            }
                                  }
                         }
        # reordered stucture:  @second_category <=> @first_category
      end

      it "updates the order for the categories" do
        post :update_categories, categories: @categories_param
        #we have reordered
        @first_category.reload
        @second_category.reload
        expect(@first_category.position).to be 1
        expect(@second_category.position).to be 0
      end

      it "renders nothing" do
        post :update_categories, categories: @categories_param
        expect(response.body).to eql(" ")
      end

      it "calls reorder categories intrinsically" do
        expect(controller).to receive(:reorder_categories).with(categories: @categories_param, parent_id: nil)
        post :update_categories, categories: @categories_param
      end
    end


    describe 'DELETE #delete_category' do
      before :each do
        @category = create(:category)
      end

      it "responds with 403 for non existing folder" do
        delete :delete_category, id: 999
        expect(response).to have_http_status(403)
      end

      it "responds with 403 if folder has products" do
        @product = create(:product)
        create(:categorization, product_id: @product.id,
                                category_id: @category.id)
        delete :delete_category, id: @category.id
        expect(response).to have_http_status(403)
      end

      it "responds with 403 if folder has children" do
        create(:category, parent: @category)
        delete :delete_category, id: @category.id
        expect(response).to have_http_status(403)
      end

      it "renders nothing after successfull deletion" do
        delete :delete_category, id: @category.id
        expect(response.body).to eql(" ")
      end
    end


    describe "POST #update_categorization" do
      before :each do
        @product = create(:product)
        @old_category = create(:category)
        @categorization = create(:categorization, product_id: @product.id,
                                                  category_id: @old_category.id )
        @new_category = create(:category)

        @params = { old_category_id: @old_category.id,
                    new_category_id: @new_category.id,
                    product_id: @product.id}
      end

      it "finds the right categorization" do
        post :update_categorization, @params
        expect(assigns(:categorization)).to eql @categorization
      end

      it "updates the categorization with the new category id" do
        post :update_categorization, @params
        expect(assigns(:categorization).category_id).to eql @new_category.id
      end

      it "returns the category name" do
        post :update_categorization, @params
        expect(response.body).to eql  @new_category.name
      end
    end

    # childrenarray is tested inherently by show_categorytree
    # reorder_categories is tested inherently by update_categories
  end
end