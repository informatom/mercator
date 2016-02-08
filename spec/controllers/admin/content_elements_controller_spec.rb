require 'spec_helper'

describe Admin::ContentElementsController, :type => :controller  do

  context "crud actions" do
    before :each do
      no_redirects and act_as_admin

      @folder = create(:folder)
      @instance = create(:content_element, folder_id: @folder.id)
      @attributes = attributes_for(:content_element, folder_id: @folder.id,
                                                     name_de: "yet another name")
      @invalid_attributes = attributes_for(:content_element, name_de: nil)
    end

    it_behaves_like("crud actions")


    describe 'GET #index' do
      it "searches for name_de" do
        get :index, search: "deutsche"
        expect(assigns(:content_elements).count).to eql 1
      end

      it "searches for name_en" do
        get :index, search: "english"
        expect(assigns(:content_elements).count).to eql 1
      end

      it "if term not searchable, nothing is returned" do
        get :index, search: "not findable"
        expect(assigns(:content_elements).count).to eql 0
      end
    end


    describe 'GET #new' do
      it "sets the folder_id from params folder" do
        get :new, folder: 17
        expect(assigns(:content_element).folder_id).to eql 17
      end
    end


    describe 'POST #create' do
      it "redirects to contentmanager front path" do
        post :create, content_element: @attributes
        expect(response).to redirect_to contentmanager_front_path
      end

      it "sets the session" do
        post :create, content_element: @attributes
        expect(session[:selected_content_element_id]).to eql assigns(:content_element).id
        expect(session[:selected_folder_id]).to eql @folder.id
      end
    end


    describe 'GET #edit' do
      it "sets the session" do
        get :edit, id: @instance
        expect(session[:selected_content_element_id]).to eql @instance.id
        expect(session[:selected_folder_id]).to eql @folder.id
      end
    end


    describe 'PATCH #update' do
      it "redirects to contentmanager front path" do
        patch :update, id: @instance, content_element: { name_de: "new name" }
        expect(response).to redirect_to contentmanager_front_path
      end

      it "sets the session" do
        patch :update, id: @instance, content_element: { name_de: "new name" }
        expect(session[:selected_content_element_id]).to eql @instance.id
        expect(session[:selected_folder_id]).to eql @folder.id
      end
    end


    describe 'DELETE #destroy' do
      it "renders nothing for xhr request" do
        xhr :delete, :destroy, id: @instance
        expect(response.body).to eql("")
      end
    end
  end
end