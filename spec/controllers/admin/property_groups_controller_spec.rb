require 'spec_helper'

describe Admin::PropertyGroupsController, :type => :controller do
  describe "crud actions" do
    before :each do
      no_redirects and act_as_admin

      @instance = create(:property_group)
      @attributes = attributes_for(:property_group)
      @invalid_attributes = attributes_for(:property_group, name_de: nil)
    end

    it_behaves_like("crud actions")


    describe 'GET #index' do
      it "finds the records" do
        get :index
        expect(assigns(:property_groups).count).to eql 1
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
                                                         name_de: "property group",
                                                         name_en: "property group",
                                                         position: 42}]}.to_json)
      end
    end


    describe 'DELETE #destroy' do
      it "responds with 403 for non existing folder" do
        delete :destroy, id: 999
        expect(response).to have_http_status(403)
      end

      it "responds with 403 if folder has values" do
        value = create(:value, property_group_id: @instance.id,
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
        post :create, property_group: @attributes,
                      page_path: "http://marcator.informatom.com/path?product_id=17&value_id=23"
        expect(session[:seleted_value]).to eql 23
      end

      it "redirects to productmanager property manager path of this product if product id given" do
        post :create, property_group: @attributes,
                      page_path: "http://marcator.informatom.com/path?product_id=17"
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
        patch :update, id: @instance, property_group: { name_de: "neuer Name" },
                       page_path: "http://marcator.informatom.com/path?product_id=17&value_id=23"
        expect(session[:seleted_value]).to eql 23
      end

      it "redirects to productmanager property manager path of this product if product id given" do
        patch :update, id: @instance, property_group: { name_de: "neuer Name" },
                       page_path: "http://marcator.informatom.com/path?product_id=17"
        expect(response).to redirect_to productmanager_property_manager_path(17)
      end
    end
  end
end