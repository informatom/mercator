require 'spec_helper'

describe MercatorMesonic::OrderItem do

  # ---  Class Methods  --- #

  context "setup" do
    it "knows its table name" do
      expect(MercatorMesonic::OrderItem.table_name).to eql "T026"
    end

    it "knows its primary key" do
      expect(MercatorMesonic::OrderItem.primary_key).to eql "c000"
    end
  end

  # ---  Class Methods  --- #

  describe "initialize_mesonic" do
    before :each do
      @user = create(:user, erp_account_nr: "1I20533-2004-1368")
      @date = Time.now
      @mesonic_order = instance_double( MercatorMesonic::Order, c000: "999900-26011515",
                                                                c027: @date,
                                                                c021: "account number",
                                                                c022: "order number" )
      @order = create(:order, user_id: @user.id)
      @product = create(:product_with_inventory_and_two_prices)
      @lineitem = create(:lineitem, user_id: @user.id,
                                    order_id: @order.id,
                                    product_id: @product.id)
      @mesoyear = MercatorMesonic::AktMandant.mesoyear
      @mesocomp = MercatorMesonic::AktMandant.mesocomp
    end

    it "initializes a record" do
      expect().to be_a MercatorMesonic::OrderItem
    end

    it "sets the attributes" do
      @new_record = MercatorMesonic::OrderItem.initialize_mesonic(mesonic_order: @mesonic_order,
                                                                  lineitem: @lineitem,
                                                                  customer: @user,
                                                                  index: 17)

      expect(@new_record.c000).to eql "999900-26011515-000018"
      expect(@new_record.c003).to eql "nr123"
      expect(@new_record.c004).to eql "Artikel Eins Zwei Drei"
      expect(@new_record.c005).to eql 42.0
      expect(@new_record.c006).to eql 42.0
      expect(@new_record.c007).to eql 123.45
      expect(@new_record.c008).to eql 0.0
      expect(@new_record.c009).to eql 4002
      expect(@new_record.c010).to eql 20
      expect(@new_record.c011).to eql 1
      expect(@new_record.c012).to eql 17
      expect(@new_record.c013).to eql 0
      expect(@new_record.c014).to eql 42
      expect(@new_record.c015).to eql nil
      expect(@new_record.c016).to eql 0.0
      expect(@new_record.c018).to eql 0.0
      expect(@new_record.c019).to eql 0.0
      expect(@new_record.c020).to eql 0.0
      expect(@new_record.c021).to eql 0.0
      expect(@new_record.c022).to eql 0.0
      expect(@new_record.c023).to eql 0.0
      expect(@new_record.c024).to eql nil
      expect(@new_record.c025).to eql @date
      expect(@new_record.c026).to eql 400
      expect(@new_record.c027).to eql 0
      expect(@new_record.c031).to eql 5184.9
      expect(@new_record.c032).to eql 0
      expect(@new_record.c033).to eql nil
      expect(@new_record.c034).to eql 5.0
      expect(@new_record.c035).to eql 0
      expect(@new_record.c042).to eql 1
      expect(@new_record.c044).to eql "account number"
      expect(@new_record.c045).to eql "order number"
      expect(@new_record.c046).to eql 99
      expect(@new_record.c047).to eql nil
      expect(@new_record.c048).to eql Date.today.year
      expect(@new_record.c052).to eql 0.0
      expect(@new_record.c054).to eql 0
      expect(@new_record.c055).to eql 42
      expect(@new_record.c056).to eql 20533
      expect(@new_record.c057).to eql 0
      expect(@new_record.c058).to eql 0
      expect(@new_record.c059).to eql 0
      expect(@new_record.c060).to eql 0
      expect(@new_record.c061).to eql 0
      expect(@new_record.c062).to eql 0
      expect(@new_record.c063).to eql 0
      expect(@new_record.c068).to eql 1
      expect(@new_record.c070).to eql 0.0
      expect(@new_record.c071).to eql 0.0
      expect(@new_record.c072).to eql 0.0
      expect(@new_record.c073).to eql 1
      expect(@new_record.c074).to eql 0
      expect(@new_record.c075).to eql 0
      expect(@new_record.c077).to eql 0
      expect(@new_record.c078).to eql 18
      expect(@new_record.c081).to eql 0
      expect(@new_record.c082).to eql 0.0
      expect(@new_record.c083).to eql 20.0
      expect(@new_record.c085).to eql 2
      expect(@new_record.c086).to eql 0.0
      expect(@new_record.c087).to eql 0.0
      expect(@new_record.c088).to eql 0.0
      expect(@new_record.c091).to eql 0
      expect(@new_record.c092).to eql 0.0
      expect(@new_record.c098).to eql 0
      expect(@new_record.c099).to eql 0.0
      expect(@new_record.c100).to eql 0.0
      expect(@new_record.c101).to eql 0.0
      expect(@new_record.c104).to eql 0
      expect(@new_record.C106).to eql ""
      expect(@new_record.C107).to eql 0.0
      expect(@new_record.C108).to eql ""
      expect(@new_record.C109).to eql 0
      expect(@new_record.mesocomp).to eql @mesocomp
      expect(@new_record.mesoyear).to eql @mesoyear
      expect(@new_record.mesoprim).to eql "999900-26011515-000018-" + @mesocomp.to_s + "-" + @mesoyear.to_s
    end
  end
end