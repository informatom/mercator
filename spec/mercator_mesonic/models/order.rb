require 'spec_helper'

describe MercatorMesonic::Order do

  # ---  Class Methods  --- #

  context "setup" do
    it "knows its table name" do
      expect(MercatorMesonic::Order.table_name).to eql "T025"
    end

    it "knows its primary key" do
      expect(MercatorMesonic::Order.primary_key).to eql "C000"
    end
  end


  context "scopes" do
    before :each do
      @mesoyear = MercatorMesonic::AktMandant.mesoyear
      @mesocomp = MercatorMesonic::AktMandant.mesocomp
    end

    it "has a scope mesocomp" do
      expect(MercatorMesonic::Belegart.unscoped.mesocomp.pluck(:C000))
                            .to match_array MercatorMesonic::Belegart.unscoped.where(mesocomp: @mesocomp).pluck(:C000)
    end

    it "has a scope mesoyear" do
      expect(MercatorMesonic::Belegart.unscoped.mesoyear.pluck(:C000))
                            .to match_array MercatorMesonic::Belegart.unscoped.where(mesoyear: @mesoyear).pluck(:C000)
    end


    it "performs the default scope" do
      expect(MercatorMesonic::Belegart.pluck(:C000))
                            .to match_array MercatorMesonic::Belegart.unscoped.mesocomp.mesoyear.pluck(:C000)
    end
  end


  # ---  Class Methods  --- #

  describe "initialize_mesonic" do
    before :each do
      create(:country)
      @user = create(:user, erp_account_nr: "1I20533-2004-1368")
      @date = Time.now

      @order = create(:order, user_id: @user.id)
      @product = create(:product_with_inventory_and_two_prices)
      @lineitem = create(:lineitem, user_id: @user.id,
                                    order_id: @order.id,
                                    product_id: @product.id)
      @mesoyear = MercatorMesonic::AktMandant.mesoyear
      @mesocomp = MercatorMesonic::AktMandant.mesocomp

      # I'm picking this particular record, because it relates to a webshop belegart
      # and unless a record is saved, it's seems not to resolve relations, what we need for c034
      @kontenstamm_fakt = MercatorMesonic::KontenstammFakt.find("691801-2004-1380")
    end

    it "initializes a record" do
      expect(MercatorMesonic::Order.initialize_mesonic(order: @order,
                                                       custom_order_number: "my order number",
                                                       mesonic_kontenstamm_fakt: @kontenstamm_fakt)).to be_a MercatorMesonic::Order
    end

    it "sets the attributes" do
      @new_record = MercatorMesonic::Order.initialize_mesonic(order: @order,
                                                              custom_order_number: "my order number",
                                                              mesonic_kontenstamm_fakt: @kontenstamm_fakt)
      expect(@new_record.c000).to eql "09WEB-my order number"
      expect(@new_record.c003).to eql "Herr Dr"
      expect(@new_record.c004).to eql "Bigcorp"
      expect(@new_record.c005).to eql "Max Mustermann - Finanzabteilung"
      expect(@new_record.c006).to eql "Musterstraße 123"
      expect(@new_record.c007).to eql "1234"
      expect(@new_record.c008).to eql "Musterstadt"
      expect(@new_record.c009).to eql "Herr Dr."
      expect(@new_record.c010).to eql "Bigcorp"
      expect(@new_record.c011).to eql "Max Mustermann - Finanzabteilung"
      expect(@new_record.c012).to eql "Musterstraße 123"
      expect(@new_record.c013).to eql "1234"
      expect(@new_record.c014).to eql "Musterstadt"
      expect(@new_record.c017).to eql "AT"
      expect(@new_record.c019).to eql "AT"
      expect(@new_record.c020).to eql 0
      expect(@new_record.c021).to eql "09WEB"
      expect(@new_record.c022).to eql "my order number"
      expect(@new_record.c023).to eql "N"
      expect(@new_record.c024).to eql "N"
      expect(@new_record.c025).to eql "N"
      expect(@new_record.c026).to eql "N"
      expect(Time.now - @new_record.c027 < 5.seconds).to eql true
      expect(@new_record.c030).to eql 20533
      expect(@new_record.c034).to eql nil # FIXME: seriously? -> mesonic_kontenstamm_fakt.belegart.c014 is actually nil
      expect(@new_record.c035).to eql "21"
      expect(@new_record.c036).to eql 99
      expect(@new_record.c037).to eql 0
      expect(@new_record.c038).to eql 0.0
      expect(@new_record.c039).to eql 0
      expect(@new_record.c040).to eql 0.0
      expect(@new_record.c041).to eql 0
      expect(@new_record.c047).to eql 3
      expect(@new_record.c049).to eql 0.0
      expect(@new_record.c050).to eql 0.0
      expect(@new_record.c051).to eql 25
      expect(@new_record.c053).to eql nil
      expect(@new_record.c054).to eql 400
      expect(@new_record.c056).to eql 0.0
      expect(@new_record.c057).to eql 0
      expect(Time.now - @new_record.c059 < 5.seconds).to eql true
      expect(@new_record.c074).to eql 0
      expect(@new_record.c075).to eql 0
      expect(@new_record.c076).to eql 0
      expect(@new_record.c077).to eql 0
      expect(@new_record.c078).to eql 0
      expect(@new_record.c080).to eql 0.0
      expect(@new_record.c081).to eql "Finanzabteilung"
      expect(@new_record.c082).to eql "Finanzabteilung"
      expect(@new_record.c086).to eql 0
      expect(@new_record.c088).to eql 0
      expect(@new_record.c089).to eql 1
      expect(@new_record.c090).to eql 0
      expect(@new_record.c091).to eql 0
      expect(@new_record.c092).to eql 0
      expect(@new_record.c093).to eql 0
      expect(@new_record.c094).to eql 0
      expect(@new_record.c095).to eql 0
      expect(@new_record.c096).to eql 0
      expect(@new_record.c097).to eql 1011
      expect(@new_record.c098).to eql 101
      expect(@new_record.c099).to eql 6066.333
      expect(@new_record.c100).to eql 6066.333
      expect(@new_record.c102).to eql 0.0
      expect((Time.now + 3.days) - @new_record.c103 < 5.seconds).to eql true
      expect(@new_record.c104).to eql 0
      expect(@new_record.c105).to eql 0
      expect(@new_record.c106).to eql 0.0
      expect(@new_record.c109).to eql -1
      expect(@new_record.c111).to eql 2
      expect(@new_record.c113).to eql "09WEB"
      expect(@new_record.c114).to eql 0.0
      expect(@new_record.c115).to eql 101
      expect(@new_record.c116).to eql 101
      expect(@new_record.c117).to eql 101
      expect(@new_record.c118).to eql 0.0
      expect(@new_record.c120).to eql 0.0
      expect(@new_record.c121).to eql 0
      expect(@new_record.c123).to eql 0
      expect(@new_record.c126).to eql 0
      expect(@new_record.c127).to eql 0
      expect(@new_record.c137).to eql 2
      expect(@new_record.c139).to eql 0
      expect(@new_record.c140).to eql 0
      expect(@new_record.c141).to eql 0
      expect(@new_record.c142).to eql 0
      expect(@new_record.c143).to eql 0
      expect(@new_record.C151).to eql 8
      expect(@new_record.C152).to eql "900001"
      expect(@new_record.C153).to eql 0
      expect(@new_record.C154).to eql 0.0
      expect(@new_record.C155).to eql 0
      expect(@new_record.C156).to eql 0
      expect(@new_record.C157).to eql 0
      expect(@new_record.C158).to eql 0
      expect(@new_record.C159).to eql 0
      expect(@new_record.C160).to eql 0
      expect(@new_record.mesocomp).to eql @mesocomp
      expect(@new_record.mesoyear).to eql @mesoyear
      expect(@new_record.mesoprim).to eql "09WEB-my order number-" + @mesocomp.to_s + "-" + @mesoyear.to_s
    end
  end
end