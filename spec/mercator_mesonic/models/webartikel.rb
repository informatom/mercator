require 'spec_helper'

describe MercatorMesonic::Webartikel do

  context "setup" do
    it "knows its table name" do
      expect(MercatorMesonic::Webartikel.table_name).to eql "WEBARTIKEL"
    end

    it "knows its primary key" do
      expect(MercatorMesonic::Webartikel.primary_key).to eql "Artikelnummer"
    end
  end

  it "has many mesonic_prices" do
    it {should have_many :mesonic_prices}
  end


  # ---  Class Methods  --- #

  describe "import" do
    before :each do
      allow_any_instance_of(MercatorMesonic::Webartikel).to receive(:import_and_return_product).and_return(Product.new(number: "dummy"))
      expect_any_instance_of(Product).to receive(:save).at_least(10).times.and_return(true)
      expect(MercatorMesonic::Webartikel).to receive(:remove_orphans).and_return(true)
      expect(Product).to receive(:deprecate).and_return(true)
      expect(::Category).to receive(:reactivate).and_return(true)
      expect(::Category).to receive(:reindexing_and_filter_updates).and_return(true)
    end

    it "coordinates all the import steps" do
      MercatorMesonic::Webartikel.import(update: "full")
      # expect(MercatorMesonic::Webartikel.instance_variable_get(:@webartikel).count).to eql MercatorMesonic::Webartikel.count
    end

    it 'deletes the Inventories that will be recreated' do
      @product = create(:product, number: "HP-CE989A")
      @inventory = create(:inventory, erp_updated_at: Time.now - 1.hour,
                                      product_id: @product.id,
                                      number: "HP-CE989A")
      MercatorMesonic::Webartikel.import(update: "all")
      expect(Inventory.where(id: @inventory.id)).to be_empty
    end

    it 'deletes the Prices that will be recreated' do
      @product = create(:product, number: "HP-CE989A")
      @inventory = create(:inventory, erp_updated_at: Time.now - 1.hour,
                                      product_id: @product.id,
                                      number: "HP-CE989A")
      @price = create(:price, inventory_id: @inventory.id)
      MercatorMesonic::Webartikel.import(update: "all")
      expect(::Price.where(id: @price.id)).to be_empty
    end

    it "selects only changed_webarticles of update: changed" do
      create(:inventory, erp_updated_at: Time.now - 1.month)
      MercatorMesonic::Webartikel.import(update: "changed")
      expect(MercatorMesonic::Webartikel.instance_variable_get(:@webartikel).count < 100).to eql true
    end

    it "selects only relevant webrarticles for update: missing" do
      @product = create(:product, number: "HP-CE989A")
      MercatorMesonic::Webartikel.import(update: "missing")
      expect(MercatorMesonic::Webartikel.instance_variable_get(:@webartikel).count < MercatorMesonic::Webartikel.count).to eql true
    end
  end


  describe "remove_orphans" do
    before :each do
      @product = create(:product)
      @new_orphaned_inventory = create(:inventory, just_imported: true,
                                                   product_id: @product.id)
      @old_orphaned_inventory = create(:inventory, just_imported: false,
                                                   product_id: @product.id)
      @new_inventory = create(:inventory, just_imported: true,
                                          product_id: @product.id,
                                          number: "HP-CE989A")
      @old_inventory = create(:inventory, just_imported: false,
                                          product_id: @product.id,
                                          number: "HP-CE989A")
    end

    it "deletes all orphaned inventories, if only_old: false" do
      MercatorMesonic::Webartikel.remove_orphans(only_old: false)
      expect(MercatorMesonic::Webartikel.instance_variable_get(:@inventories).count).to eql 2
    end

    it "deletes only old orphaned inventories, if only_old: true" do
      MercatorMesonic::Webartikel.remove_orphans(only_old: true)
      expect(MercatorMesonic::Webartikel.instance_variable_get(:@inventories).count).to eql 3
    end

    it "sets just imported to false for all remaining inventories" do
      MercatorMesonic::Webartikel.remove_orphans(only_old: true)
      expect(Inventory.where(just_imported: false).count).to eql 3
    end
  end


  describe "test connection" do
    it "returns true for connection established" do
      expect(MercatorMesonic::Webartikel.test_connection).to eql true
    end
  end


  describe "non unique" do
    it "finds non unique Artikelnummers" do
      @non_unique_article_numbers = MercatorMesonic::Webartikel.non_unique
      expect(MercatorMesonic::Webartikel.where(Artikelnummer: @non_unique_article_numbers.first).count > 1).to eql true
    end
  end


# This is a consistency test for the database
# Test takes forever, code itself is not relevant for the application)
  # describe "duplicates" do
  #   it "returns (hopefully) no duplilate entries" do
  #     expect(MercatorMesonic::Webartikel.duplicates).to eql []
  #   end
  # end


# Test takes forever, code itself is not relevant for the application
  # describe "differences" do
  #   it "creates entries in Logentry table" do
  #     MercatorMesonic::Webartikel.differences
  #     expect(Logentry.count > 0).to eql true
  #   end
  # end


  describe "count_aktionen" do
    it "counts the number of discounts" do
      expect(MercatorMesonic::Webartikel.count_aktionen > 0).to eql true
    end
  end


  describe "update_categorizations" do
    it "deletes all categorizations and creates categorizations for all webartikel" do
      create(:product, number: "HP-C8S58A")
      expect(Categorization).to receive_message_chain(:all, :delete_all)
      expect_any_instance_of(MercatorMesonic::Webartikel).to receive(:create_categorization).and_return(true)
      expect_any_instance_of(Product).to receive(:save).and_return(true)
      MercatorMesonic::Webartikel.update_categorizations
    end
  end


  describe "categorize_from_properties" do
    context "schnaeppchen" do
      before :each do
        @schnaeppchen_category = create(:category, name_de: "Schnäppchen")
        @schnaeppchen = create(:product, number: "HP-419805-045")
      end

      it "finds schnaeppchennumbers" do
        MercatorMesonic::Webartikel.categorize_from_properties
        expect(MercatorMesonic::Webartikel.instance_variable_get(:@schnaeppchen_numbers)).to eql ["V7-L15R",
          "HP-419805-045", "HP-FA777AA", "HP-419523-045", "HP-FA736AA", "HP-J9085A", "HP-D8905A",
          "HP-D5063M", "HP-D5063A", "HP-P7600T", "HP-F4876JT", "HP-F4890JT"]
      end

      it "finds schnaeppchen category" do
        MercatorMesonic::Webartikel.categorize_from_properties
        expect(MercatorMesonic::Webartikel.instance_variable_get(:@schnaeppchen_category)).to eql @schnaeppchen_category
      end

      it "creates categorization for schnaeppchen into schnaeppchen category" do
        MercatorMesonic::Webartikel.categorize_from_properties
        expect(@schnaeppchen.categories.first).to eql @schnaeppchen_category
      end

      it 'sets the position in the schnaeppchen categorization' do
        MercatorMesonic::Webartikel.categorize_from_properties
        expect(@schnaeppchen.categorizations.first.position).to eql 1
      end
    end


    context "topprodukte" do
      before :each do
        @topprodukte = ::Category.topseller
        @topprodukt = create(:product, number: "HP-EM718AA")
      end

      it "finds topprodukte numbers" do
        MercatorMesonic::Webartikel.categorize_from_properties
        expect(MercatorMesonic::Webartikel.instance_variable_get(:@topprodukte_numbers)).to eql ["HP-L1596A",
          "HP-470062-687", "AOCLM925", "HP-PU885AA", "HP-PT603ET", "HP-DH180S", "HP-PE679AV",
          "HP-EY366EA", "HP-DU305T", "HP-L1510A", "HP-EM718AA", "HP-PC766A", "DIV33-092-200",
          "HP-AH047AA", "HP-EE418AA", "DC7800CMTWT", "HP-RA374AA", "HP-DC7900CMTWT",
          "HP-DC7900SFFWT", "2200-07242-120", "2200-07300-120", "2200-07880-122", "2200-16200-122",
          "POL2200-17910-122", "FEHBSDRIVE-AES", "HP-DC7900USDTWT", "HP-J9085A", "HP-KE289AT",
          "HP-D8905A", "HP-D5063M", "HP-D5063A", "HP-P7600T", "HP-F4887JT", "HP-C8108A-BUNDLE",
          "HP-306942-041", "HP-470060-647", "HP-470058-801", "HP-DB107T", "HP-DD153T", "HP-DG223T", "HP-DJ318T"]
      end

      it "finds topprodukte category" do
        MercatorMesonic::Webartikel.categorize_from_properties
        expect(MercatorMesonic::Webartikel.instance_variable_get(:@topprodukte_category)).to eql @topprodukte
      end

      it "creates categorization for topprodukt into topprodukte category" do
        MercatorMesonic::Webartikel.categorize_from_properties
        expect(@topprodukt.categories.first).to eql @topprodukte
      end

      it 'sets the position in the topprodukte categorization' do
        MercatorMesonic::Webartikel.categorize_from_properties
        expect(@topprodukt.categorizations.first.position).to eql 1
      end
    end


    context "fireworks", focus: true do
      before :each do
        @fireworks = create(:category, name_de: "Feuerwerk")
        @firework = create(:product, number: "HP-Q2428A")
      end

      it "finds fireworks numbers" do
        MercatorMesonic::Webartikel.categorize_from_properties
        expect(MercatorMesonic::Webartikel.instance_variable_get(:@fireworks_numbers).first(20)).to eql ["HP-470045-208",
          "HP-F5387JT", "HP-P9592T", "HP-470037-596", "HP-X1053T", "HP-XW6200TC", "HP-C9656A",
          "HP-C9657A", "HP-C9658A", "HP-C9659A", "HP-Q3388B", "HP-Q2428A", "HP-Q2431A", "HP-Q2448A",
          "HP-Q2432A", "HP-Q2433A", "HP-Q2434A", "HP-DJ256A", "HP-DU434ET", "HP-PW127ES"]
      end

      it "finds fireworks category" do
        MercatorMesonic::Webartikel.categorize_from_properties
        expect(MercatorMesonic::Webartikel.instance_variable_get(:@fireworks_category)).to eql @fireworks
      end

      it "creates categorization for firework into fireworks category" do
        MercatorMesonic::Webartikel.categorize_from_properties
        expect(@firework.categories.first).to eql @fireworks
      end

      it 'sets the position in the firework categorization' do
        MercatorMesonic::Webartikel.categorize_from_properties
        expect(@firework.categorizations.first.position).to eql 1
      end
    end
  end


  # ---  instance Methods  --- #

  it "is readonly" do
    expect(MercatorMesonic::Webartikel.new().readonly?).to eql true
  end


  describe "import_and_return_product" do
    it "" do
      FIXME!
    end
  end


  describe "create_product" do
    it "" do
      FIXME!
    end
  end


  describe "create_inventory" do
    it "" do
      FIXME!
    end
  end


  describe "create_price" do
    it "" do
      FIXME!
    end
  end


  describe "create_recommendations" do
    it "" do
      FIXME!
    end
  end


  describe "comment" do
    it "displays Langtext 2 if no Langtext 1" do
      expect(MercatorMesonic::Webartikel.find("HP-462967-B21").comment).to eql "Für HP Proliant BL, DL und ML Serien"
    end

    it "displays Langtext 1 and 2, if both present" do
      expect(MercatorMesonic::Webartikel.find("FEHBSDRIVE-AES").comment).to eql "biometrics secured" +
        " USB Flash Drive integrated on-the-fly AES (256-Bit) en-/decryption engine"
    end
  end


  describe "create_categorization" do
    it "" do
      FIXME!
    end
  end


  describe "product_variations" do
    it "returns variations" do
      @metadatum = MercatorMesonic::Webartikel.find("HP-CE989A")
      expect(@metadatum.product_variations).to eql ["HP-CE989A;0001", "HP-CE989A;0002",
        "HP-CE989A;0003", "HP-CE989A;0004", "HP-CE989A;0005", "HP-CE989A;0006", "HP-CE989A;0007",
        "HP-CE989A;0008", "HP-CE989A;0009", "HP-CE989A;0010", "HP-CE989A;0011", "HP-CE989A;0012",
        "HP-CE989A;0013", "HP-CE989A;0014", "HP-CE989A;0015", "HP-CE989A;0016", "HP-CE989A;0017",
        "HP-CE989A;0018", "HP-CE989A;0019", "HP-CE989A;0020", "HP-CE989A;0021", "HP-CE989A;0022",
        "HP-CE989A;0023", "HP-CE989A;0024", "HP-CE989A;0025"]
    end
  end
end