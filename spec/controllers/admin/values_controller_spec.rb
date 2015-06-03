require 'spec_helper'

describe Admin::ValuesController, :type => :controller do

  describe "crud actions" do
    before :each do
      no_redirects and act_as_admin

      @instance = create(:value, state: "textual",
                                 amount: nil,
                                 flag: nil)
      @invalid_attributes = attributes_for(:value, amount: nil).except(:state)
    end

    it_behaves_like("crud actions")

    describe 'GET #index' do
      it "finds the records" do
        get :index
        expect(assigns(:values).count).to eql 1
      end

      it "searches for title_de" do
        get :index, search: {"0"=> {field: "title_de", value: "Wert"}}
        expect(assigns(:values)).to match_array([@instance])
      end

      it "searches for message" do
        get :index, search: {"0"=> {field: "title_en", value: "Value"}}
        expect(assigns(:values)).to match_array([@instance])
      end

      it "searches returns nil if nothing found" do
        get :index, search: {"0"=> {field: "title_de", value: "not here"}}
        expect(assigns(:values)).to match_array([])
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
                                                         amount: nil,
                                                         flag: nil,
                                                         product_number: "123",
                                                         property: "property",
                                                         property_group: "property group",
                                                         title_de: "Deutscher Wert",
                                                         title_en: "English Value",
                                                         unit_de: "kg",
                                                         unit_en: "kg"}]}.to_json)
      end
    end

    describe 'DELETE #destroy' do
      it "redirects to #index" do
        delete :destroy, id: @instance
        expect(response).to be_redirect
      end

      it "renders status: success for xhr request" do
        xhr :delete, :destroy, id: @instance
        expect(response.body).to be_json_eql({ status: "success"}.to_json)
      end
    end
  end
end