require 'spec_helper'

describe Admin::LogentriesController, :type => :controller do
  describe "crud actions" do
    before :each do
      no_redirects and act_as_admin
      @instance = create(:logentry)
    end

    it_behaves_like("crud show")
    it_behaves_like("crud new")
    it_behaves_like("crud edit")


    describe 'GET #index' do
      it "renders the :index template" do
        get :index
        expect(assigns(:logentries).count).to eql 1
      end

      it "searches for severity" do
        get :index, search: {"0"=> {field: "severity", value: "info"}}
        expect(assigns(:logentries)).to match_array([@instance])
      end

      it "searches for message" do
        get :index, search: {"0"=> {field: "message", value: "message"}}
        expect(assigns(:logentries)).to match_array([@instance])
      end

      it "searches returns nil if nothing found" do
        get :index, search: {"0"=> {field: "message", value: "not here"}}
        expect(assigns(:logentries)).to match_array([])
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
                                                          severity: "info",
                                                          message: "Just a message.",
                                                          created_at: "2015-06-03 10:53:47"}]}.to_json)
      end
    end


    describe 'POST #create' do
      it "with data it redirects to  #show" do
        post :create, logentry: attributes_for(:logentry)
        expect(response).to redirect_to admin_logentry_path(assigns(:logentry))
      end
    end


    describe 'PATCH #update' do
      it "with correct data it redirects to #show" do
        patch :update, id: @instance,
                       logentry: attributes_for(:logentry)
        expect(response).to redirect_to admin_logentry_path(assigns(:logentry))
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