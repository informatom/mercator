 require 'spec_helper'

describe Admin::ProductsController, :type => :controller do
  before :each do
    no_redirects and act_as_productmanager
    @instance = create(:product)
  end

  describe "crud actions" do
    before :each do
      @invalid_attributes = attributes_for(:product, title_de: nil).except(:state)
    end

    it_behaves_like("crud actions")

    describe "GET #index" do
      it "searches for title_de" do
        get :index, search: "default product"
        expect(assigns(:products)).to match_array([@instance])
      end

      it "searches for title_en" do
        get :index, search: "Article One Two Three"
        expect(assigns(:products)).to match_array([@instance])
      end

      it "searches for state" do
        get :index, search: "active"
        expect(assigns(:products)).to match_array([@instance])
      end

      it "searches for number" do
        get :index, search: "123"
        expect(assigns(:products)).to match_array([@instance])
      end

      it "searches returns nil if nothing found" do
        get :index, search: "not in products record"
        expect(assigns(:products)).to match_array([])
      end
    end
  end


  describe "catch orphans" do
    it "catches orphans" do
      expect(Product).to receive(:catch_orphans)
      get :catch_orphans
    end

    it "redirects to admin logentries path" do
      get :catch_orphans
      expect(response).to redirect_to admin_logentries_path
    end
  end


  describe "index_invalid" do
    it "reads invalid records" do
      @invalid_record = build(:product, title_de: nil)
      @invalid_record.save(validate: false)

      get :index_invalid
      expect(assigns(:errorsarray)).to eql [[@instance.id, {:number=>["has already been taken"]}],
                                            [@invalid_record.id, {:title_de=>["can't be blank"],
                                                 :number=>["has already been taken"]}]]
    end

    it "renders template" do
      get :index_invalid
    end
  end


  describe "reindex" do
    it "reindexes products" do
      expect(Product).to receive(:reindex)
      get :reindex
    end

    it "redirects to admin logentries path" do
      create(:dummy_customer)

      get :reindex
      expect(response).to redirect_to admin_logentries_path
    end
  end
end