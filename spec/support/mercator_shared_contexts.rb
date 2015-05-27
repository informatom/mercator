module MercatorSharedContexts
  # We expect Hobo to be correct, so we only need to test if the response to the request is handled

  shared_context 'crud actions' do
    it_behaves_like("crud show")
    it_behaves_like("crud index")
    it_behaves_like("crud new")
    it_behaves_like("crud create")
    it_behaves_like("crud edit")
    it_behaves_like("crud update")
    it_behaves_like("crud destroy")
  end


  shared_context 'crud except destroy' do
    it_behaves_like("crud show")
    it_behaves_like("crud index")
    it_behaves_like("crud new")
    it_behaves_like("crud create")
    it_behaves_like("crud edit")
    it_behaves_like("crud update")
  end

  shared_context 'crud except create' do
    it_behaves_like("crud show")
    it_behaves_like("crud index")
    it_behaves_like("crud new")
    it_behaves_like("crud edit")
    it_behaves_like("crud update")
    it_behaves_like("crud destroy")
  end


  shared_context 'crud show' do
    describe 'GET #show' do
      it "renders the :show template" do
        get :show, id: @instance
        expect(response).to render_template :show
      end
    end
  end


  shared_context 'crud index' do
    describe 'GET #index' do
      it "renders the :index template" do
        get :index
        expect(response).to render_template :index
      end
    end
  end


  shared_context 'crud new' do
    describe 'GET #new' do
      it "renders the :index template" do
        get :new
        expect(response).to render_template :new
      end
    end
  end


  shared_context 'crud create' do
    describe 'POST #create' do
      it "without data it rerenders #new" do
        post :create
        expect(response).to render_template :new
      end
    end
  end


  shared_context 'crud edit' do
    describe 'GET #edit' do
      it "renders the :show template" do
        get :edit, id: @instance
        expect(response).to render_template :edit
      end
    end
  end


  shared_context 'crud update' do
    describe 'PATCH #update' do
      it "with_incorrect data it redirects to #show" do
        patch :update, id: @instance,
                       @instance.class.to_s.underscore => @invalid_attributes
        expect(response).to render_template :edit
      end
    end
  end


  shared_context 'crud destroy' do
    describe 'DELETE #destroy' do
      it "redirects to #index" do
        delete :destroy, id: @instance
        expect(response).to be_redirect
      end
    end
  end
end