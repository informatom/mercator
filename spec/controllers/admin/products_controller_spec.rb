 require 'spec_helper'

describe Admin::ProductsController, :type => :controller do
  before :each do
    no_redirects and act_as_productmanager
    @instance = create(:product)
  end

  context "crud actions" do
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

      it "can export a CSV file", focus: true do
        User.send(:remove_const, :JOBUSER) # just to avoid warning in the next line
        User::JOBUSER = create(:jobuser)
        create(:product_with_inventory_and_two_prices)

        get :index, format: :csv
        expect(response.body).to eql("price,id,title_de,number,created_at,updated_at,state," +
        "key_timestamp,photo_file_name,photo_content_type,photo_file_size,photo_updated_at," +
        "document_file_name,document_content_type,document_file_size,document_updated_at," +
        "description_de,description_en,title_en,legacy_id,long_description_de,long_description_en," +
        "warranty_de,warranty_en,not_shippable,alternative_number\n" +
        "-,1,default product,123," + @instance.created_at.to_s + "," + @instance.created_at.to_s + ",active,,,,,,,,,," +
        "\"Deutsch: Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ullam, aliquid.\"," +
        "\"English: Lorem ipsum dolor sit amet, consectetur adipisicing elit. Similique, repellat!\"" +
        ",Article One Two Three,,\"Deutsch: Lorem ipsum dolor sit amet, consectetur adipisicing" +
        " elit. Ullam, aliquid.\",\"English: Lorem ipsum dolor sit amet, consectetur adipisicing" +
        " elit. Similique, repellat!\",Ein Jahr mit gewissen Einschränkungen,One year with " +
        "evereal restrictions,,alternative 123\n" +
        "42.0,2,default product,product_with_inventory_and_two_prices," + @instance.created_at.to_s +
        "," + @instance.created_at.to_s + ",active,,,,,,,,,,\"Deutsch: Lorem" +
        " ipsum dolor sit amet, consectetur adipisicing elit. Ullam, aliquid.\",\"English: Lorem" +
        " ipsum dolor sit amet, consectetur adipisicing elit. Similique, repellat!\",Article One " +
        "Two Three,,\"Deutsch: Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ullam," +
        " aliquid.\",\"English: Lorem ipsum dolor sit amet, consectetur adipisicing elit." +
        " Similique, repellat!\",Ein Jahr mit gewissen Einschränkungen,One year with evereal" +
        " restrictions,,alternative 123\n")
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


  describe "lifecycle actions" do
    describe "activate" do
      it "is available for new" do
        @instance.state = "new"
        expect(@instance.lifecycle.can_activate? @productmanager).to be
      end
    end


    describe "deactivate" do
      it "is available for new" do
        @instance.state = "new"
        expect(@instance.lifecycle.can_deactivate? @productmanager).to be
      end

      it "is available for active" do
        @instance.state = "active"
        expect(@instance.lifecycle.can_deactivate? @productmanager).to be
      end
    end


    describe "reactivate" do
      it "is available for deprecated" do
        @instance.state = "deprecated"
        expect(@instance.lifecycle.can_reactivate? @productmanager).to be
      end
    end
  end
end