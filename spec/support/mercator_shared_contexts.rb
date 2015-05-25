module MercatorSharedContexts

  shared_context 'crud actions' do
      # We expect Hobo to be correct, so we only need to test if the response to the request is handled
    describe 'GET #show' do
      it "renders the :show template" do
        get :show, id: @instance
        expect(response).to render_template :show
      end
    end

    describe 'GET #index' do
      it "renders the :index template" do
        get :index
        expect(response).to render_template :index
      end
    end

    describe 'GET #new' do
      it "renders the :index template" do
        get :new
        expect(response).to render_template :new
      end
    end

    describe 'POST #create' do
      it "without data it rerenders #new" do
        post :create
        expect(response).to render_template :new
      end
    end

    describe 'GET #edit' do
      it "renders the :show template" do
        get :edit, id: @instance
        expect(response).to render_template :edit
      end
    end

    describe 'PATCH #update' do
      it "with_incorrect data it redirects to #show" do
        patch :update, id: @instance, address: @instance_attributes
        expect(response).to render_template :edit
      end
    end

    describe 'DELETE #destroy' do
      it "redirects to #index" do
        delete :destroy, id: @instance
        expect(response).to redirect_to @delete_redirect
      end
    end
  end
end