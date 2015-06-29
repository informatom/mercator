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
    it "coordinates all the import steps" do
      create(:inventory, erp_updated_at: Time.now - 1.hour)

      allow_any_instance_of(MercatorMesonic::Webartikel).to receive(:import_and_return_product).and_return(Product.new)
      expect_any_instance_of(Product).to receive(:save).at_least(1400).times.and_return(true)
      expect(MercatorMesonic::Webartikel).to receive(:remove_orphans).and_return(true)
      expect(Product).to receive(:deprecate).and_return(true)
      expect(::Category).to receive(:reactivate).and_return(true)
      expect(::Category).to receive(:reindexing_and_filter_updates).and_return(true)

      MercatorMesonic::Webartikel.import(update: "full")
    end

    it 'deletes the Inventories that will be recreated', focus: true do
    end

    it 'deletes the Prices that will be recreated' do
    end

    it "selects only changed_webarticles of update: changed" do
    end

    it "selects only relevant webrarticles for update: missing" do
    end
  end


  describe "remove_orphans" do
    it "" do
      FIXME!
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
    it "" do
      FIXME!
    end
  end


  describe "categorize_from_properties" do
    it "" do
      FIXME!
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