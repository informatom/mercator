require 'spec_helper'

describe Admin::PropertiesController, :type => :controller do
  describe "crud actions" do
    before :each do
      no_redirects and act_as_admin

      @instance = create(:property)
      @attributes = attributes_for(:property)
      @invalid_attributes = attributes_for(:property, name_de: nil)
    end

    it_behaves_like("crud actions")

    describe 'GET #index' do
      it "finds the records" do
        get :index
        expect(assigns(:properties).count).to eql 1
      end

      it "responds empty for html requests" do
        get :index
        expect(response.body).to eql ""
      end

      it "responds with correct json" do
        request.headers["accept"] = 'application/json'
        get :index
        expect(response.body).to be_json_eql({status: "success",
                                              total: 1,
                                              records: [{recid: @instance.id,
                                                         datatype: "textual",
                                                         icecat_id: 42,
                                                         name_de: "Eigenschaft",
                                                         name_en: "property",
                                                         position: 1 }]}.to_json)
      end
    end


    describe 'DELETE #destroy' do
      it "responds with 403 for non existing folder" do
        delete :destroy, id: 999
        expect(response).to have_http_status(403)
      end

      it "responds with 403 if folder has values" do
        value = create(:value, property_id: @instance.id,
                               state: "textual",
                               amount: nil,
                               flag: nil)
        delete :destroy, id: @instance
        expect(response).to have_http_status(403)
      end

      it "renders nothing for xhr request" do
        xhr :delete, :destroy, id: @instance
        expect(response.body).to eql(" ")
      end
    end


    describe 'GET #new' do
      it "sets cancelpath if product id given" do
        get :new, product_id: 17
        expect(assigns(:cancelpath)).to eql productmanager_property_manager_path(17)
      end
    end


    describe 'POST #create' do
      it "sets session seleted value if value id given" do
        post :create, property: @attributes,
                      page_path: "http://mercator.informatom.com/path?product_id=17&value_id=23"
        expect(session[:seleted_value]).to eql 23
      end

      it "redirects to productmanager property manager path of this product if product id given" do
        post :create, property: @attributes,
                      page_path: "http://mercator.informatom.com/path?product_id=17"
        expect(response).to redirect_to productmanager_property_manager_path(17)
      end
    end


    describe 'GET #edit' do
      it "sets cancelpath if product id given" do
        get :edit, id: @instance, product_id: 17
        expect(assigns(:cancelpath)).to eql productmanager_property_manager_path(17)
      end
    end


    describe 'PATCH #update' do
      it "sets session seleted value if value id given" do
        patch :update, id: @instance, property: { name_de: "neuer Name" },
                       page_path: "http://mercator.informatom.com/path?product_id=17&value_id=23"
        expect(session[:seleted_value]).to eql 23
      end

      it "redirects to productmanager property manager path of this product if product id given" do
        patch :update, id: @instance, property: { name_de: "neuer Name" },
                       page_path: "http://mercator.informatom.com/path?product_id=17"
        expect(response).to redirect_to productmanager_property_manager_path(17)
      end
    end
  end

  describe "lifecycle actions" do
    describe "PUT #do_filter" do
      before :each do
        no_redirects and act_as_admin
        @instance = create(:property, state: "unfilterable")
        @category = create(:category)
      end

      it "reads the category" do
        put :do_filter, id: @instance.id, category_id: @category.id
        expect(assigns(:category)).to eql @category
      end

      it "updates the porperty hash on category" do
        expect_any_instance_of(Category).to receive(:update_property_hash)
        put :do_filter, id: @instance.id, category_id: @category.id
      end

      it "redirects to edit_properties_admin_category_path for the category provided" do
        put :do_filter, id: @instance.id, category_id: @category.id
        expect(response).to redirect_to edit_properties_admin_category_path(@category)
      end

      it "is available for unfilterable" do
        @instance.state = "unfilterable"
        expect(@instance.lifecycle.can_filter? @admin).to be
      end
    end


    describe "PUT #do_dont_filter" do
      before :each do
        no_redirects and act_as_admin
        @instance = create(:property, state: "filterable")
        @category = create(:category)
      end


      it "reads the category" do
        put :do_dont_filter, id: @instance.id, category_id: @category.id
        expect(assigns(:category)).to eql @category
      end

      it "updates the porperty hash on category" do
        expect_any_instance_of(Category).to receive(:update_property_hash)
        put :do_dont_filter, id: @instance.id, category_id: @category.id
      end

      it "redirects to edit_properties_admin_category_path for the category provided" do
        put :do_dont_filter, id: @instance.id, category_id: @category.id
        expect(response).to redirect_to edit_properties_admin_category_path(@category)
      end

      it "is available for filterable" do
        @instance.state = "filterable"
        expect(@instance.lifecycle.can_dont_filter? @admin).to be
      end
    end
  end
end