require 'spec_helper'

describe Admin::LogentriesController, :type => :controller do
  describe "crud actions" do
    before :each do
      no_redirects and act_as_admin

      @instance = create(:logentry)
      @attributes = attributes_for(:logentry)
    end

    it_behaves_like("crud show")
    it_behaves_like("crud new")
    it_behaves_like("crud create")
    it_behaves_like("crud edit")


    describe 'GET #index' do
      it "renders the :index template" do
        get :index
        expect(assigns(:logentries).count).to eql 1
      end
    end


    describe 'PATCH #update' do
      it "with correct data it renders #show" do
        patch :update, id: @instance,
                       logentry: @attributes
        expect(response).to render_template :edit
      end
    end


    describe 'DELETE #destroy' do
      it "redirects to #index" do
        delete :destroy, id: @instance
        expect(response).to be_redirect
      end
    end
  end
end