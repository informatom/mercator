require 'spec_helper'

describe Admin::FoldersController, :type => :controller do

  context "crud actions" do
    before :each do
      no_redirects and act_as_admin

      @instance = create(:folder)
      @invalid_attributes = attributes_for(:folder, name: nil)
    end

    it_behaves_like("crud actions")


    describe "POST #update" do
      it "fills selected_folder_id in session" do
        patch :update, id: @instance,
                       @instance.class.to_s.underscore => @invalid_attributes
        expect(session[:selected_folder_id]).to eql @instance.id
      end
    end


    describe "POST #create" do
      it "fills selected_folder_id in session" do
        post :create, folder: attributes_for(:folder)
        expect(session[:selected_folder_id]).to eql(assigns(:folder).id)
      end
    end


    describe 'DELETE #destroy' do
      it "responds with 403 for non existing folder" do
        delete :destroy, id: 999
        expect(response).to have_http_status(403)
      end

      it "responds with 403 if folder has content_elements" do
        create(:content_element, folder: @instance)
        delete :destroy, id: @instance
        expect(response).to have_http_status(403)
      end

      it "responds with 403 if folder has children" do
        create(:folder, parent: @instance)
        delete :destroy, id: @instance
        expect(response).to have_http_status(403)
      end
    end
  end
end