require 'spec_helper'

describe FrontController, :type => :controller do

  describe 'GET #index' do
    it "renders the :index template" do
      get :index
      expect(response).to render_template :index
    end
  end


  describe 'GET #home' do
    it 'redirects to categories#index if it is a shopdomain request' do
      Constant.send(:remove_const, :SHOPDOMAIN) # just to avoid warning in the next line
      Constant::SHOPDOMAIN = "shop.domain.com"
      allow(request).to receive(:host) { "shop.domain.com" }

      get :home
      expect(response).to redirect_to categories_path(locale: nil)
    end

    it 'redirects to "webpages/home" if there exists such a webpage and it is a cmsdomain request' do
      allow(request).to receive(:host) { "cms.domain.com" }
      create(:webpage, slug: 'home')

      get :home
      expect(response).to redirect_to '/webpages/home'
    end

    it 'redirects to "front#index" otherwise' do
      allow(request).to receive(:host) { "cms.domain.com" }

      get :home
      expect(response).to redirect_to front_path
    end
  end


  context 'search actions' do
    before :each do
      create(:dummy_customer)
      @product = create(:product, title_de: "search term",
                                  state: "active")
      @category = create(:category, name_de: "search term",
                                    state: "active")
      Product.reindex
      Category.reindex
    end

    describe 'GET #search' do
      it 'runs a search' do
        get :search, query: "search term"
        expect(assigns(:search_results)).to eql ["Kategorien", @category, "Artikel", @product]
      end

      it 'renders the #search template' do
        get :search
        expect(response).to render_template :search
      end
    end


    describe 'POST #search' do
      it 'runs a search' do
        post :search, query: "search term"
        expect(assigns(:search_results)).to eql ["Kategorien", @category, "Artikel", @product]
      end

      it 'renders the #search template' do
        post :search
        expect(response).to render_template :search
      end
    end
  end
end