require 'spec_helper'

describe Contracting::ContractitemsController, :type => :controller do
  context "crud actions" do
    before :each do
      no_redirects and act_as_sales
      @user = create(:user)

      @contract = create(:contract)
      @instance = create(:contractitem, contract_id: @contract.id)
    end

    it_behaves_like("crud index")


    describe "GET #index" do
      it "returns the correct json" do
        @second_contractitem = create(:second_contractitem, contract_id: @instance.contract_id,
                                                            product_id: @instance.product_id)

        get :index, contract_id: @instance.contract_id, format: :text
        expect(response.body).to be_json_eql( {records: [ { amount: 12,
                                                            enddate: "2017-12-31",
                                                            marge: "8.0",
                                                            position: 12,
                                                            product_number: "123",
                                                            product_title: "Zweiter Artikel",
                                                            recid: @second_contractitem.id,
                                                            startdate: "2016-01-01",
                                                            term: 24,
                                                            vat: "10.0",
                                                            volume: 0,
                                                            volume_bw: 7000,
                                                            volume_color: 4000 },
                                                          { amount: 42,
                                                            enddate: "2016-08-02",
                                                            marge: "10.0",
                                                            position: 124,
                                                            product_number: "123",
                                                            product_title: "Artikel Eins Zwei Drei",
                                                            recid: @instance.id,
                                                            startdate: "2015-08-03",
                                                            term: 12,
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
          @second_product = create(:second_product)

          @params = {cmd: "save-record",
                     recid: "0",
                     record: { position: 7,
                               term: 17,
                               startdate: "2015-03-03",
                               product_number: "a product number",
                               product_title: "a product title",
                               product_id: @second_product.id,
                               amount: 27,
                               marge: 7.5,
                               volume_bw: 7777,
                               volume_color: 777,
                               product_price: 77.7,
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
          expect(assigns(:contractitem).startdate).to eq Date.new(2015, 3, 3)
          expect(assigns(:contractitem).product_number).to eq "a product number"
          expect(assigns(:contractitem).product_title).to eq "a product title"
          expect(assigns(:contractitem).product_id).to eq @second_product.id
          expect(assigns(:contractitem).amount).to eq 27
          expect(assigns(:contractitem).marge).to eq 7.5
          expect(assigns(:contractitem).volume_bw).to eq 7777
          expect(assigns(:contractitem).volume_color).to eq 777
          expect(assigns(:contractitem).value).to eq 0.0
          expect(assigns(:contractitem).vat).to eq 19
          expect(assigns(:contractitem).contract_id).to eq @instance.contract_id
        end

        it "returns the correct json" do
          post :manage, @params
          expect(response.body).to be_json_eql({ record: { amount: 27,
                                                           contract_id: @instance.contract_id,
                                                           marge: "7.5",
                                                           position: 7,
                                                           product_id: @second_product.id,
                                                           product_number: "a product number",
                                                           product_title: "a product title",
                                                           recid: assigns(:contractitem).id,
                                                           startdate: "2015-03-03",
                                                           term: 17,
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
                                                           year5: "2019-08-03" },
                                                         { title: "Jahresende",
                                                           year1: "2016-08-02",
                                                           year2: "2017-08-02",
                                                           year3: "2018-08-02",
                                                           year4: "2019-08-02",
                                                           year5: "2020-08-02" },
                                                         { title: "Rate (EUR)",
                                                           year1: "EUR 1,17",
                                                           year2: "EUR 7,00",
                                                           year3: "EUR 4,67",
                                                           year4: "EUR 5,83",
                                                           year5: "EUR 7,00" },
                                                         { title: "Monate ohne Rate",
                                                           year1: 0,
                                                           year2: 5,
                                                           year3: 0,
                                                           year4: 0,
                                                           year5: "---" },
                                                         { title: "Rate im Folgemonat (EUR)",
                                                           year1: "EUR 7,00",
                                                           year2: "EUR 4,67",
                                                           year3: "EUR 5,83",
                                                           year4: "EUR 7,00",
                                                           year5: "---" },
                                                         { title: "Summe Gutschrift/Nachzahlung",
                                                           year1: "EUR 0,00",
                                                           year2: "-EUR 28,00",
                                                           year3: "EUR 14,00",
                                                           year4: "EUR 14,00",
                                                           year5: "EUR 14,00" },
                                                         { title: "=== Tatsächliche Raten ===",
                                                           year1: nil,
                                                           year2: nil,
                                                           year3: nil,
                                                           year4: nil,
                                                           year5: nil },
                                                         { title: "Januar",
                                                           year1: "EUR 1,17",
                                                           year2: "EUR 7,00",
                                                           year3: "EUR 0,00",
                                                           year4: "EUR 5,83",
                                                           year5: "EUR 7,00" },
                                                         { title: "Februar",
                                                           year1: "EUR 1,17",
                                                           year2: "EUR 7,00",
                                                           year3: "EUR 0,00",
                                                           year4: "EUR 5,83",
                                                           year5: "EUR 7,00" },
                                                         { title: "März",
                                                           year1: "EUR 1,17",
                                                           year2: "EUR 7,00",
                                                           year3: "EUR 0,00",
                                                           year4: "EUR 5,83",
                                                           year5: "EUR 7,00" },
                                                         { title: "April",
                                                           year1: "EUR 1,17",
                                                           year2: "EUR 7,00",
                                                           year3: "EUR 0,00",
                                                           year4: "EUR 5,83",
                                                           year5: "EUR 7,00" },
                                                         { title: "Mai",
                                                           year1: "EUR 1,17",
                                                           year2: "EUR 7,00",
                                                           year3: "EUR 0,00",
                                                           year4: "EUR 5,83",
                                                           year5: "EUR 7,00" },
                                                         { title: "Juni",
                                                           year1: "EUR 1,17",
                                                           year2: "EUR 7,00",
                                                           year3: "EUR 4,67",
                                                           year4: "EUR 5,83",
                                                           year5: "EUR 7,00" },
                                                         { title: "Juli",
                                                           year1: "EUR 1,17",
                                                           year2: "EUR 7,00",
                                                           year3: "EUR 4,67",
                                                           year4: "EUR 5,83",
                                                           year5: "EUR 7,00" },
                                                         { title: "August",
                                                           year1: "EUR 1,17",
                                                           year2: "EUR 7,00",
                                                           year3: "EUR 4,67",
                                                           year4: "EUR 5,83",
                                                           year5: "EUR 7,00" },
                                                         { title: "September",
                                                           year1: "EUR 1,17",
                                                           year2: "EUR 7,00",
                                                           year3: "EUR 4,67",
                                                           year4: "EUR 5,83",
                                                           year5: "EUR 7,00" },
                                                         { title: "Oktober",
                                                           year1: "EUR 1,17",
                                                           year2: "EUR 7,00",
                                                           year3: "EUR 4,67",
                                                           year4: "EUR 5,83",
                                                           year5: "EUR 7,00" },
                                                         { title: "November",
                                                           year1: "EUR 1,17",
                                                           year2: "EUR 7,00",
                                                           year3: "EUR 4,67",
                                                           year4: "EUR 5,83",
                                                           year5: "EUR 7,00" },
                                                         { title: "Dezember",
                                                           year1: "EUR 1,17",
                                                           year2: "EUR 7,00",
                                                           year3: "EUR 4,67",
                                                           year4: "EUR 5,83",
                                                           year5: "EUR 7,00" }],
                                               status: "success",
                                               total: 19 }.to_json)
      end
    end
  end
end