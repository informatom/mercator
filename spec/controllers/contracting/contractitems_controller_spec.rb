require 'spec_helper'

describe Contracting::ContractitemsController, :type => :controller do
  context "crud actions" do
    before :each do
      no_redirects and act_as_sales
      @user = create(:user)

      @contract = create(:contract, consultant_id: @sales.id,
                                    customer_id: @user.id)
      @instance = create(:contractitem, contract_id: @contract.id,
                                        user_id: @user.id)
    end

    it_behaves_like("crud index")


    describe "GET #index" do
      it "returns the correct json" do
        @second_contractitem = create(:second_contractitem, user_id: @instance.user_id,
                                                            contract_id: @instance.contract_id,
                                                            product_id: @instance.product_id,
                                                            toner_id: @instance.toner_id)

        get :index, contract_id: @instance.contract_id, format: :text
        expect(response.body).to be_json_eql( {records: [ { amount: 12,
                                                            description_de: "Zweiter Artikel",
                                                            description_en: "Second Article",
                                                            discount_abs: "4.0",
                                                            enddate: "2017-12-31",
                                                            marge: "8.0",
                                                            monitoring_rate: "6.0",
                                                            position: 12,
                                                            product_number: "123",
                                                            product_price: "12.3",
                                                            recid: @second_contractitem.id,
                                                            startdate: "2016-01-01",
                                                            term: 24,
                                                            toner: "HP-TR0815",
                                                            unit: "Liter",
                                                            user: "john.doe@informatom.com",
                                                            value: "2.0",
                                                            vat: "10.0",
                                                            volume: 0,
                                                            volume_bw: 7000,
                                                            volume_color: 4000 },
                                                          { amount: 42,
                                                            description_de: "Artikel Eins Zwei Drei",
                                                            description_en: "Article One Two Three",
                                                            discount_abs: "3.0",
                                                            enddate: "2016-08-02",
                                                            marge: "10.0",
                                                            monitoring_rate: "5.0",
                                                            position: 124,
                                                            product_number: "123",
                                                            product_price: "123.45",
                                                            recid: @instance.id,
                                                            startdate: "2015-08-03",
                                                            term: 12,
                                                            toner: "HP-TR0815",
                                                            unit: "Stück",
                                                            user: "john.doe@informatom.com",
                                                            value: "2.0",
                                                            vat: "20.0",
                                                            volume: 0,
                                                            volume_bw: 10000,
                                                            volume_color: 5000 }
                                                        ],
                                               status: "success",
                                               total: 2 }.to_json)
      end
    end


    describe "POST #manage" do
      context "creating a new contractitem" do
        before :each do
          @second_customer = create(:dummy_customer)
          @second_product = create(:second_product)
          @second_toner = create(:second_toner)

          @params = {cmd: "save-record",
                     recid: "0",
                     record: { position: 7,
                               term: 17,
                               user_id: @second_customer.id,
                               startdate: "2015-03-03",
                               product_number: "a product number",
                               product_id: @second_product.id,
                               toner_id: @second_toner.id,
                               description_de: "Eine andere Beschreibung",
                               description_en: "A different description",
                               amount: 27,
                               unit: "pieces",
                               marge: 7.5,
                               volume_bw: 7777,
                               volume_color: 777,
                               product_price: 77.7,
                               monitoring_rate: 7,
                               discount_abs: 17,
                               value: 777,
                               vat: 19,
                               contract_id: @instance.contract_id},
                     id: "0"}

          JsonSpec.configure {exclude_keys "created_at", "updated_at"}
        end

        after :each do
          JsonSpec.configure {exclude_keys "created_at", "updated_at", "id"}
        end

        it "creates a new contractitem if save record with recid 0" do
          post :manage, @params
          expect(assigns(:contractitem)).to be_a Contractitem
        end

        it "sets the contractitem attributes" do
          post :manage, @params
          expect(assigns(:contractitem).position).to eq 7
          expect(assigns(:contractitem).term).to eq 17
          expect(assigns(:contractitem).user_id).to eq @second_customer.id
          expect(assigns(:contractitem).startdate).to eq Date.new(2015, 3, 3)
          expect(assigns(:contractitem).product_number).to eq "a product number"
          expect(assigns(:contractitem).product_id).to eq @second_product.id
          expect(assigns(:contractitem).toner_id).to eq @second_toner.id
          expect(assigns(:contractitem).description_de).to eq "Eine andere Beschreibung"
          expect(assigns(:contractitem).description_en).to eq "A different description"
          expect(assigns(:contractitem).amount).to eq 27
          expect(assigns(:contractitem).unit).to eq "pieces"
          expect(assigns(:contractitem).marge).to eq 7.5
          expect(assigns(:contractitem).volume_bw).to eq 7777
          expect(assigns(:contractitem).volume_color).to eq 777
          expect(assigns(:contractitem).product_price).to eq 77.7
          expect(assigns(:contractitem).monitoring_rate).to eq 7
          expect(assigns(:contractitem).discount_abs).to eq 17
          expect(assigns(:contractitem).value).to eq -10
          expect(assigns(:contractitem).vat).to eq 19
          expect(assigns(:contractitem).contract_id).to eq @instance.contract_id
        end

        it "returns the correct json" do
          post :manage, @params
          expect(response.body).to be_json_eql({ record: { amount: 27,
                                                           contract_id: @instance.contract_id,
                                                           description_de: "Eine andere Beschreibung",
                                                           description_en: "A different description",
                                                           discount_abs: "17.0",
                                                           marge: "7.5",
                                                           monitoring_rate: "7.0",
                                                           position: 7,
                                                           product_id: @second_product.id,
                                                           product_number: "a product number",
                                                           product_price: "77.7",
                                                           recid: assigns(:contractitem).id,
                                                           startdate: "2015-03-03",
                                                           term: 17,
                                                           toner: "Toner gelb",
                                                           toner_id: @second_toner.id,
                                                           unit: "pieces",
                                                           user: "dummy.customer@informatom.com",
                                                           user_id: @second_customer.id,
                                                           value: "-10.0",
                                                           vat: "19.0",
                                                           volume_bw: 7777,
                                                           volume_color: 777 },
                                                 status: "success"} .to_json)
        end
      end
    end


    describe "DELETE #delete" do
      it "finds the right contractitem" do
        post :delete, id: @instance.id
        expect(assigns(:contractitem)).to eql @instance
      end

      it "deletes the contractitem" do
        post :delete, id: @instance.id
        expect(Contractitem.where(id: @instance.id)).to be_empty
      end

      it "renders nothing" do
        post :delete, id: @instance.id
        expect(response.body).to eql(" ")
      end

      it "blocks deletetion, if there are contractitemitems" do
        create(:consumableitem, contractitem_id: @instance.id)

        post :delete, id: @instance.id
        expect(Contractitem.find(@instance.id)).to eql @instance
      end
    end


    describe "GET #calendar" do
      it "returns the correct json" do
        create(:consumableitem, contractitem_id: @instance.id)

        get :calendar, id: @instance.id, format: :text
        expect(response.body).to be_json_eql( {records: [{ title: "Jahresbeginn",
                                                           year1: "2015-08-03",
                                                           year2: "2016-08-03",
                                                           year3: "2017-08-03",
                                                           year4: "2018-08-03",
                                                           year5: "2019-08-03",
                                                           year6: "2020-08-03" },
                                                         { title: "Jahresende",
                                                           year1: "2016-08-02",
                                                           year2: "2017-08-02",
                                                           year3: "2018-08-02",
                                                           year4: "2019-08-02",
                                                           year5: "2020-08-02",
                                                           year6: "2021-08-02" },
                                                         { title: "Monate ohne Rate",
                                                           year1: 12,
                                                           year2: 0,
                                                           year3: 0,
                                                           year4: 0,
                                                           year5: 0,
                                                           year6: "---" },
                                                         { title: "Folgeraten (EUR)",
                                                           year1: "---",
                                                           year2: "EUR 3,44",
                                                           year3: "EUR 3,44",
                                                           year4: "EUR 4,58",
                                                           year5: "EUR 5,73",
                                                           year6: "EUR 0,00" },
                                                         { title: "Folgemonat (EUR)",
                                                           year1: "-EUR 0,00",
                                                           year2: "-EUR 0,00",
                                                           year3: "-EUR 13,75",
                                                           year4: "-EUR 13,75",
                                                           year5: "-EUR 13,75",
                                                           year6: "---" },
                                                         { title: "Folgeraten mit Monitoring (EUR)",
                                                           year1: "---",
                                                           year2: "EUR 8,44",
                                                           year3: "EUR 8,44",
                                                           year4: "EUR 9,58",
                                                           year5: "EUR 10,73",
                                                           year6: "EUR 6,88" },
                                                         { title: "Summe Gutschrift/Nachzahlung",
                                                           year1: "-EUR 41,25",
                                                           year2: "EUR 0,00",
                                                           year3: "EUR 13,75",
                                                           year4: "EUR 13,75",
                                                           year5: "EUR 13,75",
                                                           year6: "EUR 0,00" }
                                                        ],
                                               status: "success",
                                               total: 7 }.to_json)
      end
    end
  end
end