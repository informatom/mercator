require 'spec_helper'

describe Productmanager::PropertyManagerController, :type => :controller do
  context "actions" do
    before :each do
      no_redirects && act_as_productmanager
    end


    describe "index" do
      before :each do
        @product = create(:product)
      end

      it 'finds the product' do
        get :index, id: @product.id
        expect(assigns(:product)).to eql @product
      end

      it "renders the correct json" do
        get :index, id: @product.id, format: "text"
        expect(response.body).to be_json_eql({ records: [{ attribute: "Number",
                                                           recid: 1,
                                                           value: "123"},
                                                         { attribute: "Title DE",
                                                           recid: 2,
                                                           value: "default product"},
                                                         { attribute: "Title EN",
                                                           recid: 3,
                                                           value: "Article One Two Three"},
                                                         { attribute: "Description DE",
                                                           recid: 4,
                                                           value: "Deutsch: Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ullam, aliquid."},
                                                         { attribute: "Description EN",
                                                           recid: 5,
                                                           value: "English: Lorem ipsum dolor sit amet, consectetur adipisicing elit. Similique, repellat!"},
                                                         { attribute: "Long Description DE",
                                                           recid: 6,
                                                           value: "Deutsch: Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ullam, aliquid."},
                                                         { attribute: "Long Description EN",
                                                           recid: 7,
                                                           value: "English: Lorem ipsum dolor sit amet, consectetur adipisicing elit. Similique, repellat!"},
                                                         { attribute: "Warranty DE",
                                                           recid: 8,
                                                           value: "Ein Jahr mit gewissen Einschränkungen"},
                                                         { attribute: "Warranty EN",
                                                           recid: 9,
                                                           value: "One year with evereal restrictions"},
                                                         { attribute: "Created at",
                                                           recid: 10,
                                                           value: I18n.l(Time.now)},
                                                         { attribute: "Updated at",
                                                           recid: 11,
                                                           value: I18n.l(Time.now)} ],
                                               status: "success",
                                               total: 13 }.to_json)
      end
    end


    describe "GET #show_properties" do
      before :each do
        @first_property = create(:property)
        @second_property = create(:second_property)
      end

      it "finds the properties" do
        get :show_properties
        expect(assigns(:properties)).to match_array [@first_property, @second_property]
      end

      it "renders the correct json" do
        get :show_properties
        expect(response.body).to be_json_eql({ records: [{ datatype: "textual",
                                                           name: "property",
                                                           position: 1,
                                                           recid: @first_property.id },
                                                         { datatype: "textual",
                                                           name: "second Property",
                                                           position: 2,
                                                           recid: @second_property.id } ],
                                               status: "success",
                                               total: 2 }.to_json)
      end
    end


    describe "GET #show_properties" do
      before :each do
        @first_property_group = create(:property_group)
        @second_property_group = create(:second_property_group)
      end

      it "finds the property_groups" do
        get :show_property_groups
        expect(assigns(:property_groups)).to match_array [@first_property_group,
                                                         @second_property_group]
      end

      it "renders the correct json" do
        get :show_property_groups
        expect(response.body).to be_json_eql({ records: [{ name: "property group",
                                                           position: 42,
                                                           recid: @first_property_group.id },
                                                         { name: "2. property group",
                                                           position: 43,
                                                           recid: @second_property_group.id } ],
                                               status: "success",
                                               total: 2 }.to_json)
      end
    end


    describe "GET #show_valuetree" do
      before :each do
        @product = create(:product)
        @first_property_group = create(:property_group)
        @second_property_group = create(:second_property_group)
        @first_property = create(:property)
        @second_property = create(:second_property)
        @third_property = create(:third_property)
        @fourth_property = create(:fourth_property)
        @first_value = create(:textual_value, property_id: @first_property.id,
                                              property_group_id: @first_property_group.id,
                                              product_id: @product.id)
        @second_value = create(:textual_value, property_id: @second_property.id,
                                               property_group_id: @first_property_group.id,
                                               product_id: @product.id)
        @third_value = create(:textual_value, property_id: @third_property.id,
                                              property_group_id: @second_property_group.id,
                                              product_id: @product.id)
        @fourth_value = create(:textual_value, property_id: @fourth_property.id,
                                               property_group_id: @second_property_group.id,
                                               product_id: @product.id)
      end

      it "finds the correct product" do
        get :show_valuetree, id: @product.id
        expect(assigns(:product)).to eql @product
      end

      it "returns the correct json" do
        get :show_valuetree, id: @product.id
        expect(response.body).to be_json_eql([{ children: [{ folder: false,
                                                             key: @first_value.id,
                                                             property_group_id: @first_property_group.id,
                                                             property_id: @first_property.id,
                                                             title: "property: <em style='color: orange'>text value text </em>"},
                                                           { folder: false,
                                                             key: @second_value.id,
                                                             property_group_id: @first_property_group.id,
                                                             property_id: @second_property.id,
                                                             title: "second Property: <em style='color: orange'>text value text </em>"} ],
                                                folder: true,
                                                key: @first_property_group.id,
                                                title: "property group" },
                                              { children: [{ folder: false,
                                                             key: @third_value.id,
                                                             property_group_id: @second_property_group.id,
                                                             property_id: @third_property.id,
                                                             title: "dritte Property: <em style='color: orange'>text value text </em>"},
                                                           { folder: false,
                                                             key: @fourth_value.id,
                                                             property_group_id: @second_property_group.id,
                                                             property_id: @fourth_property.id,
                                                             title: "vierte Property: <em style='color: orange'>text value text </em>"} ],
                                                folder: true,
                                                key: @second_property_group.id,
                                                title: "2. property group" } ] .to_json)
      end
    end


    describe "POST #manage_value" do
      before :each do
        @product = create(:product)
        @property_group = create(:property_group)
        @property = create(:property)
      end

      context "create record" do
        context "textual value" do
          before :each do
            @params = { cmd: "save-record",
                        recid: "0",
                        record: { product_id: @product.id.to_s,
                                  property_group_id: @property_group.id.to_s,
                                  property_id: @property.id.to_s,
                                  state: { id: "textual",
                                           text: "textartig"},
                                  flag: "0",
                                  title_de: "deutscher Text",
                                  title_en: "english text",
                                  amount: "",
                                  unit_de: "Einheiten",
                                  unit_en: "units" },
                        id: "0"}
          end

          it "checks if value exists already" do
            create(:textual_value, product_id: @product.id.to_s,
                                   property_group_id: @property_group.id.to_s,
                                   property_id: @property.id.to_s)
            post :manage_value, @params
            expect(response.body).to be_json_eql({ status: "error",
                                                   message: I18n.t("mercator.value_exists") }.to_json)
          end

          it "creates value with the correct attributes for textual value" do
            post :manage_value, @params
            expect(assigns(:value).state).to eql "textual"
            expect(assigns(:value).title_de).to eql "deutscher Text"
            expect(assigns(:value).title_en).to eql "english text"
            expect(assigns(:value).amount).to eql nil
            expect(assigns(:value).unit_de).to eql "Einheiten"
            expect(assigns(:value).unit_en).to eql "units"
            expect(assigns(:value).flag).to eql false
            expect(assigns(:value).property_group_id).to eql @property_group.id
            expect(assigns(:value).property_id).to eql @property.id
            expect(assigns(:value).product_id).to eql @product.id
          end

          it "renders the correct json" do
            post :manage_value, @params
            expect(response.body).to be_json_eql({record: { amount: nil,
                                                            flag: false,
                                                            product_id: @product.id,
                                                            property: "property",
                                                            property_group: "property group",
                                                            property_group_id: @property_group.id,
                                                            property_id: @property.id,
                                                            recid: assigns(:value).id,
                                                            state: "textual",
                                                            title_de: "deutscher Text",
                                                            title_en: "english text",
                                                            unit_de: "Einheiten",
                                                            unit_en: "units" },
                                                  status: "success" } .to_json)
          end
        end


        context "numeric value" do
          before :each do
            @params = { cmd: "save-record",
                        recid: "0",
                        record: { product_id: @product.id.to_s,
                                  property_group_id: @property_group.id.to_s,
                                  property_id: @property.id.to_s,
                                  state: { id: "numeric",
                                           text: "numerisch" },
                                  flag: "",
                                  title_de: "",
                                  title_en: "",
                                  amount: 17,
                                  unit_de: "Einheiten",
                                  unit_en: "units"},
                        id: "0"}
          end

          it "creates value with the correct attributes for numeric value" do
            post :manage_value, @params
            expect(assigns(:value).state).to eql "numeric"
            expect(assigns(:value).title_de).to eql ""
            expect(assigns(:value).title_en).to eql ""
            expect(assigns(:value).amount).to eql 17
            expect(assigns(:value).unit_de).to eql "Einheiten"
            expect(assigns(:value).unit_en).to eql "units"
            expect(assigns(:value).flag).to eql nil
            expect(assigns(:value).property_group_id).to eql @property_group.id
            expect(assigns(:value).property_id).to eql @property.id
            expect(assigns(:value).product_id).to eql @product.id
          end

          it "renders the correct json" do
            post :manage_value, @params
            expect(response.body).to be_json_eql({ record: { amount: "17.0",
                                                             flag: nil,
                                                             product_id: @product.id,
                                                             property: "property",
                                                             property_group: "property group",
                                                             property_group_id: @property_group.id,
                                                             property_id: @property.id,
                                                             recid: assigns(:value).id,
                                                             state: "numeric",
                                                             title_de: "",
                                                             title_en: "",
                                                             unit_de: "Einheiten",
                                                             unit_en: "units" },
                                                   status: "success" } .to_json)
          end
        end


        context "boolean value" do
          before :each do
            @params = { cmd: "save-record",
                        recid: "0",
                        record: { product_id: @product.id.to_s,
                                  property_group_id: @property_group.id.to_s,
                                  property: "property",
                                  property_group: "property group",
                                  property_id: @property.id.to_s,
                                  state: { id: "flag",
                                           text: "wahr/falsch" },
                                  flag: "1",
                                  amount: "",
                                  title_de: "",
                                  title_en: "",
                                  unit_de: "",
                                  unit_en: "" },
                        id: "0" }
          end

          it "creates value with the correct attributes for boolean value" do
            post :manage_value, @params
            expect(assigns(:value).state).to eql "flag"
            expect(assigns(:value).title_de).to eql ""
            expect(assigns(:value).title_en).to eql ""
            expect(assigns(:value).amount).to eql nil
            expect(assigns(:value).unit_de).to eql ""
            expect(assigns(:value).unit_en).to eql ""
            expect(assigns(:value).flag).to eql true
            expect(assigns(:value).property_group_id).to eql @property_group.id
            expect(assigns(:value).property_id).to eql @property.id
            expect(assigns(:value).product_id).to eql @product.id
          end

          it "renders the correct json" do
            post :manage_value, @params
            expect(response.body).to be_json_eql({ record: { amount: nil,
                                                             flag: true,
                                                             product_id: @product.id,
                                                             property: "property",
                                                             property_group: "property group",
                                                             property_group_id: @property_group.id,
                                                             property_id: @property.id,
                                                             recid: assigns(:value).id,
                                                             state: "flag",
                                                             title_de: "",
                                                             title_en: "",
                                                             unit_de: "",
                                                             unit_en: "" },
                                                   status: "success" } .to_json)
          end
        end
      end


      context "edit record" do
        before :each do
          @value = create(:textual_value, product_id: @product.id,
                                          property_id: @property.id,
                                          property_group_id: @property_group.id)
          @second_property_group = create(:second_property_group)
          @second_property = create(:second_property)
        end


        context "textual value" do
          before :each do
            @params = { cmd: "save-record",
                        recid: @value.id.to_s,
                        record: { recid: @value.id.to_s,
                                  state: { id: "textual",
                                           text: "textartig" },
                                  title_de: "neuer Text",
                                  title_en: "new text",
                                  amount: "",
                                  unit_de: "neue Einheit",
                                  unit_en: "new Unit",
                                  flag: "0",
                                  product_id: @product.id.to_s,
                                  property_group_id: @second_property_group.id.to_s,
                                  property_id: @second_property.id.to_s },
                        id: @value.id.to_s }
          end

          it "finds the correct value" do
            post :manage_value, @params
            expect(assigns(:value)).to eql @value
          end

          it "updates value with the correct attributes for textual value" do
            post :manage_value, @params
            expect(assigns(:value).state).to eql "textual"
            expect(assigns(:value).title_de).to eql "neuer Text"
            expect(assigns(:value).title_en).to eql "new text"
            expect(assigns(:value).amount).to eql nil
            expect(assigns(:value).unit_de).to eql "neue Einheit"
            expect(assigns(:value).unit_en).to eql "new Unit"
            expect(assigns(:value).flag).to eql false
            expect(assigns(:value).property_group_id).to eql @second_property_group.id
            expect(assigns(:value).property_id).to eql @second_property.id
            expect(assigns(:value).product_id).to eql @product.id
          end

          it "renders the correct json" do
              post :manage_value, @params
              expect(response.body).to be_json_eql({record: { amount: nil,
                                                              flag: false,
                                                              product_id: @product.id,
                                                              property: "second Property",
                                                              property_group: "2. property group",
                                                              property_group_id: @second_property_group.id,
                                                              property_id: @second_property.id,
                                                              recid: assigns(:value).id,
                                                              state: "textual",
                                                              title_de: "neuer Text",
                                                              title_en: "new text",
                                                              unit_de: "neue Einheit",
                                                              unit_en: "new Unit" },
                                                    status: "success" } .to_json)
          end
        end


        context "numeric value" do
          before :each do
            @params = { cmd: "save-record",
                        recid: @value.id.to_s,
                        record: { recid: @value.id.to_s,
                                  state: { id: "numeric",
                                           text: "numerisch"
                                           },
                                  title_de: "",
                                  title_en: "",
                                  amount: "177",
                                  unit_de: "neue Einheit",
                                  unit_en: "new Unit",
                                  flag: "0",
                                  product_id: @product.id.to_s,
                                  property_group_id: @second_property_group.id.to_s,
                                  property_id: @second_property.id.to_s },
                        id: @value.id.to_s }
          end

          it "finds the correct value" do
            post :manage_value, @params
            expect(assigns(:value)).to eql @value
          end

          it "updates value with the correct attributes for numeric value" do
            post :manage_value, @params
            expect(assigns(:value).state).to eql "numeric"
            expect(assigns(:value).title_de).to eql ""
            expect(assigns(:value).title_en).to eql ""
            expect(assigns(:value).amount).to eql 177
            expect(assigns(:value).unit_de).to eql "neue Einheit"
            expect(assigns(:value).unit_en).to eql "new Unit"
            expect(assigns(:value).flag).to eql false
            expect(assigns(:value).property_group_id).to eql @second_property_group.id
            expect(assigns(:value).property_id).to eql @second_property.id
            expect(assigns(:value).product_id).to eql @product.id
          end

          it "renders the correct json" do
              post :manage_value, @params
              expect(response.body).to be_json_eql({record: { amount: 177.to_f.to_s,
                                                              flag: false,
                                                              product_id: @product.id,
                                                              property: "second Property",
                                                              property_group: "2. property group",
                                                              property_group_id: @second_property_group.id,
                                                              property_id: @second_property.id,
                                                              recid: assigns(:value).id,
                                                              state: "numeric",
                                                              title_de: "",
                                                              title_en: "",
                                                              unit_de: "neue Einheit",
                                                              unit_en: "new Unit" },
                                                    status: "success" } .to_json)
          end
        end


        context "boolean value" do
          before :each do
            @params = { cmd: "save-record",
                        recid: @value.id.to_s,
                        record: { recid: @value.id.to_s,
                                  state: { id: "flag",
                                           text: "wahr/falsch" },
                                  title_de: "",
                                  title_en: "",
                                  amount: "",
                                  unit_de: "",
                                  unit_en: "",
                                  flag: "1",
                                  product_id: @product.id.to_s,
                                  property_group_id: @second_property_group.id.to_s,
                                  property_id: @second_property.id.to_s},
                                  id: @value.id.to_s}
          end

          it "finds the correct value" do
            post :manage_value, @params
            expect(assigns(:value)).to eql @value
          end

          it "updates value with the correct attributes for boolean value" do
            post :manage_value, @params
            expect(assigns(:value).state).to eql "flag"
            expect(assigns(:value).title_de).to eql ""
            expect(assigns(:value).title_en).to eql ""
            expect(assigns(:value).amount).to eql nil
            expect(assigns(:value).unit_de).to eql ""
            expect(assigns(:value).unit_en).to eql ""
            expect(assigns(:value).flag).to eql true
            expect(assigns(:value).property_group_id).to eql @second_property_group.id
            expect(assigns(:value).property_id).to eql @second_property.id
            expect(assigns(:value).product_id).to eql @product.id
          end

          it "renders the correct json" do
            post :manage_value, @params
            expect(response.body).to be_json_eql({record: { amount: nil,
                                                            flag: true,
                                                            product_id: @product.id,
                                                            property: "second Property",
                                                            property_group: "2. property group",
                                                            property_group_id: @second_property_group.id,
                                                            property_id: @second_property.id,
                                                            recid: assigns(:value).id,
                                                            state: "flag",
                                                            title_de: "",
                                                            title_en: "",
                                                            unit_de: "",
                                                            unit_en: "" },
                                                  status: "success" } .to_json)
          end
        end
      end


      context "show record" do
        before :each do
          @value = create(:textual_value, property_id: @property.id,
                                          property_group_id: @property_group.id,
                                          product_id: @product.id)
        end

        it "reads the correct value" do
          get :manage_value, cmd: "get-record", recid: @value.id.to_s, id: @value.id.to_s
          expect(assigns(:value)).to eql @value
        end

        it "renders the correct json" do
          get :manage_value, cmd: "get-record", recid: @value.id.to_s, id: @value.id.to_s
          expect(response.body).to be_json_eql({ record: { amount: nil,
                                                           flag: nil,
                                                           product_id: @product.id,
                                                           property: "property",
                                                           property_group: "property group",
                                                           property_group_id: @property_group.id,
                                                           property_id: @property.id,
                                                           recid: @value.id,
                                                           state: "textual",
                                                           title_de: "text value text",
                                                           title_en: "text value text",
                                                           unit_de: nil,
                                                           unit_en: nil },
                                                 status: "success" } .to_json)
        end
      end
    end


    describe "DELETE #delete_value" do
      before :each do
        @product = create(:product)
        @property_group = create(:property_group)
        @property = create(:property)
        @value = create(:textual_value, product_id: @product.id,
                                        property_id: @property.id,
                                        property_group_id: @property_group.id)
      end

      it "finds the right value" do
        post :delete_value, id: @value.id
        expect(assigns(:value)).to eql @value
      end

      it "deletes the value" do
        post :delete_value, id: @value.id
        expect(Value.where(id: @value.id)).to be_empty
      end

      it "renders nothing" do
        post :delete_value, id: @value.id
        expect(response.body).to eql(" ")
      end
    end


    describe "POST #update_property_groups_order" do
      before :each do
        @property_group = create(:property_group, position: 777)
      end

      it "finds the right property group" do
        post :update_property_groups_order, value_original: 777, value_new:778
        expect(assigns(:property_group)).to eql @property_group
      end

      it "calls the right method" do
        expect_any_instance_of(PropertyGroup).to receive(:insert_at).with(778)
        post :update_property_groups_order, value_original: 777, value_new:778
      end

      it "renders nothing" do
        post :update_property_groups_order, value_original: 777, value_new:778
        expect(response.body).to eql(" ")
      end
    end


    describe "POST #update_properties_order" do
      before :each do
        @property = create(:property, position: 777)
      end

      it "finds the right property" do
        post :update_properties_order, value_original: 777, value_new:778
        expect(assigns(:property)).to eql @property
      end

      it "calls the right method" do
        expect_any_instance_of(Property).to receive(:insert_at).with(778)
        post :update_properties_order, value_original: 777, value_new:778
      end

      it "renders nothing" do
        post :update_properties_order, value_original: 777, value_new:778
        expect(response.body).to eql(" ")
      end
    end


    describe "GET #manage_features"  do
      before :each do
        @product = create(:product)
        @feature = create(:first_feature, product_id: @product.id)
        @second_feature = create(:second_feature, product_id: @product.id)
      end

      context "edit record" do
        before :each do
          @params = { cmd: "save-records",
                      changes: { "0" => { recid: @feature.id.to_s,
                                          text_de: "neuer Text",
                                          text_en: "new text",
                                          position: "2" },
                                 "1" => { recid: @second_feature.id.to_s,
                                          text_de: "noch ein neuer Text",
                                          text_en: "another new text",
                                          position: "1" }},
                      id: @product.id.to_s }
        end

        it "updates the records with the right attributes" do
          get :manage_features, @params
          @feature.reload
          @second_feature.reload

          expect(@feature.text_de).to eql "neuer Text"
          expect(@feature.text_en).to eql "new text"
          expect(@feature.position).to eql 2
          expect(@second_feature.text_de).to eql "noch ein neuer Text"
          expect(@second_feature.text_en).to eql "another new text"
          expect(@second_feature.position).to eql 1
        end

        it "finds the right features" do
          get :manage_features, @params
          expect(assigns(:features)).to match_array [@feature, @second_feature]
        end

        it "renders the correct json" do
          get :manage_features, @params
          expect(response.body).to be_json_eql({ records: [{ position: 1,
                                                             recid: @second_feature.id,
                                                             text_de: "noch ein neuer Text",
                                                             text_en: "another new text"},
                                                           { position: 2,
                                                             recid: @feature.id,
                                                             text_de: "neuer Text",
                                                             text_en: "new text" } ],
                                                 status: "success",
                                                 total: 2 }.to_json)
        end
      end

      context "show record" do
        it "finds the right features" do
          get :manage_features, cmd: "get-records", id: @product.id
          expect(assigns(:features)).to match_array [@feature, @second_feature]
        end

        it "renders the correct json" do
          get :manage_features, cmd: "get-records", id: @product.id
          expect(response.body).to be_json_eql({ records: [{ position: 1,
                                                             recid: @feature.id,
                                                             text_de: "erstes Feature",
                                                             text_en: "first feature" },
                                                           { position: 2,
                                                             recid: @second_feature.id,
                                                             text_de: "zweites Feature",
                                                             text_en: "second feature"} ],
                                                 status: "success",
                                                 total: 2 }.to_json)
        end
      end
    end


    describe "POST #create_feature" do
      before :each do
        @product = create(:product)
        @params = { cmd: "save-record",
                    recid: "0",
                    record: { text_de: "deutscher Text",
                              text_en: "english text",
                              position: "22",
                              product_id: @product.id } }
      end

      it "creates an new record with the right paramers" do
        post :create_feature, @params
        expect(assigns(:feature).text_de).to eql "deutscher Text"
        expect(assigns(:feature).text_en).to eql "english text"
        expect(assigns(:feature).position).to eql 22
        expect(assigns(:feature).product_id).to eql @product.id
      end

      it "renders success" do
        post :create_feature, @params
        expect(response.body).to be_json_eql({ status: "success" }.to_json)
      end
    end


    describe "DELETE #delete_feature" do
      before :each do
        @feature = create(:feature)
      end

      it "finds the right feature" do
        post :delete_feature, id: @feature.id
        expect(assigns(:feature)).to eql @feature
      end

      it "deletes the feature" do
        post :delete_feature, id: @feature.id
        expect(Feature.where(id: @feature.id)).to be_empty
      end

      it "renders nothing" do
        post :delete_feature, id: @feature.id
        expect(response.body).to eql(" ")
      end
    end
  end
end