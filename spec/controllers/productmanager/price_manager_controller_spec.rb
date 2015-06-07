require 'spec_helper'

describe Productmanager::PriceManagerController, :type => :controller do
  context "actions" do
    before :each do
      no_redirects && act_as_productmanager

      @product = create(:product_with_two_inventories_and_two_prices_each)
      @inventory = @product.inventories.first
      @price = @inventory.prices.first
      JsonSpec.configure {exclude_keys "created_at", "updated_at"}
    end

    after :each do
      JsonSpec.configure {exclude_keys "created_at", "updated_at", "id"}
    end


    describe "index" do
      it "reads the correct product" do
        get :index, id: @product.id
        expect(assigns(:product)).to eql @product
      end

      it "sets prices non editable if prices_are_set_by_erp_and_therefore_not_editable set" do
        create(:prices_are_set_by_erp_and_therefore_not_editable)
        get :index, id: @product.id
        expect(assigns(:prices_editable)).to eql false
      end

      it "sets prices editable if prices_are_set_by_erp_and_therefore_not_editable is not set" do
        get :index, id: @product.id
        expect(assigns(:prices_editable)).to eql true
      end
    end


    describe "POST #manage_product" do
      context "read record" do
        it "reads the right product" do
          post :manage_product, cmd: "get-record", recid: @product.id, format: :text
          expect(assigns(:product)).to eql @product
        end

        it "returns the correct json" do
          post :manage_product, cmd: "get-record", recid: @product.id, format: :text
          expect(response.body).to be_json_eql({ record: { alternative_number: "alternative 123",
                                                           description_de: "Deutsch: Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ullam, aliquid.",
                                                           description_en: "English: Lorem ipsum dolor sit amet, consectetur adipisicing elit. Similique, repellat!",
                                                           long_description_de: "Deutsch: Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ullam, aliquid.",
                                                           long_description_en: "English: Lorem ipsum dolor sit amet, consectetur adipisicing elit. Similique, repellat!",
                                                           number: "product_with_inventory_and_two_prices",
                                                           state: { id: "active" },
                                                           title_de: "default product",
                                                           title_en: "Article One Two Three",
                                                           warranty_de: "Ein Jahr mit gewissen Einschränkungen",
                                                           warranty_en: "One year with evereal restrictions"
                                                          },
                                                 status: "success" }.to_json)
        end
      end


      context "edit record" do
        before :each do
          @attrs = { format: :text,
                     cmd: "save-record",
                     recid: @product.id.to_s,
                     record: { number: "changed number",
                               alternative_number: "changed alternative number",
                               state: { id: "announced", text: "angekündigt" },
                               title_de: "geänderter titel",
                               title_en: "changed title",
                               description_de: "geänderte Beschreibung",
                               description_en: "changed Description",
                               long_description_de: "geänderte lange Beschreibung",
                               long_description_en: "changed long Description",
                               warranty_de: "geänderte Garantie",
                               warranty_en: "changed warranty" } }
        end

        it "reads the right product" do
          post :manage_product, @attrs
          expect(assigns(:product)).to eql @product
        end

        it "updates the attributes accordingly" do
          post :manage_product, @attrs
          expect(assigns(:product).title_de).to eql "geänderter titel"
          expect(assigns(:product).title_en).to eql "changed title"
          expect(assigns(:product).number).to eql "changed number"
          expect(assigns(:product).alternative_number).to eql "changed alternative number"
          expect(assigns(:product).description_de).to eql "geänderte Beschreibung"
          expect(assigns(:product).description_en).to eql "changed Description"
          expect(assigns(:product).long_description_de).to eql "geänderte lange Beschreibung"
          expect(assigns(:product).long_description_en).to eql "changed long Description"
          expect(assigns(:product).warranty_de).to eql "geänderte Garantie"
          expect(assigns(:product).warranty_en).to eql "changed warranty"
          expect(assigns(:product).state).to eql "announced"
        end

        it "returns the correct json" do
          post :manage_product, @attrs
          expect(response.body).to be_json_eql({ record: { alternative_number: "changed alternative number",
                                                           description_de: "geänderte Beschreibung",
                                                           description_en: "changed Description",
                                                           long_description_de: "geänderte lange Beschreibung",
                                                           long_description_en: "changed long Description",
                                                           number: "changed number",
                                                           state: { id: "announced" },
                                                           title_de: "geänderter titel",
                                                           title_en: "changed title",
                                                           warranty_de: "geänderte Garantie",
                                                           warranty_en: "changed warranty" },
                                                 status: "success" }.to_json)
        end
      end


      context "create record" do
        before :each do
          @attrs =  { format: :text,
                      cmd: "save-record",
                      recid: "0",
                      record: { state: { id: "active", text: "aktiv" },
                                number: "number",
                                title_de: "Titel",
                                title_en: "Title",
                                alternative_number: "alternative number",
                                description_de: "Beschreibung",
                                description_en: "Description",
                                long_description_de: "lange Beschreibung",
                                long_description_en: "long Description",
                                warranty_de: "Garantie",
                                warranty_en: "Warranty" } }
        end

        it "creates a new product" do
          post :manage_product, @attrs
          expect(assigns(:product)).to be_a Product
        end

        it "updates the attributes accordingly" do
          post :manage_product, @attrs
          expect(assigns(:product).title_de).to eql "Titel"
          expect(assigns(:product).title_en).to eql "Title"
          expect(assigns(:product).number).to eql "number"
          expect(assigns(:product).alternative_number).to eql "alternative number"
          expect(assigns(:product).description_de).to eql "Beschreibung"
          expect(assigns(:product).description_en).to eql "Description"
          expect(assigns(:product).long_description_de).to eql "lange Beschreibung"
          expect(assigns(:product).long_description_en).to eql "long Description"
          expect(assigns(:product).warranty_de).to eql "Garantie"
          expect(assigns(:product).warranty_en).to eql "Warranty"
          expect(assigns(:product).state).to eql "active"
        end

        it "returns the correct json" do
          post :manage_product, @attrs
          expect(response.body).to be_json_eql({ record: { alternative_number: "alternative number",
                                                           description_de: "Beschreibung",
                                                           description_en: "Description",
                                                           long_description_de: "lange Beschreibung",
                                                           long_description_en: "long Description",
                                                           number: "number",
                                                           state: { id: "active" },
                                                           title_de: "Titel",
                                                           title_en: "Title",
                                                           warranty_de: "Garantie",
                                                           warranty_en: "Warranty" },
                                                 status: "success" }.to_json)
        end
      end
    end


    describe "GET #show_inventories" do
      it "reads the right inventories" do
        get :show_inventories, id: @product.id
        expect(assigns(:inventories)).to match_array @product.inventories
      end

      it "returns the correct json" do
        get :show_inventories, id: @product.id
        expect(response.body).to be_json_eql({ records: [{ alternative_number: "slipper-4-2",
                                                           amount: "12.0",
                                                           charge: "ABC42",
                                                           comment_de: "in 3 Wochen lieferbar",
                                                           comment_en: "available in 3 weeks",
                                                           delivery_time: "2 Wochen",
                                                           erp_article_group: 17,
                                                           erp_characteristic_flag: 42,
                                                           erp_provision_code: 42,
                                                           erp_updated_at: "Wednesday, 22 Jan 2014, 15:23",
                                                           erp_vatline: 20,
                                                           infinite: true,
                                                           just_imported: true,
                                                           name_de: "Halbschuh Größe 37",
                                                           name_en: "Slipper Size 8",
                                                           number: "slipper-42",
                                                           recid: @product.inventories[0].id,
                                                           size: "42",
                                                           storage: "DG",
                                                           unit: "Stk.",
                                                           weight: "0.5" },
                                                         { alternative_number: "slipper-4-2",
                                                           amount: "12.0",
                                                           charge: "ABC42",
                                                           comment_de: "in 3 Wochen lieferbar",
                                                           comment_en: "available in 3 weeks",
                                                           delivery_time: "2 Wochen",
                                                           erp_article_group: 17,
                                                           erp_characteristic_flag: 42,
                                                           erp_provision_code: 42,
                                                           erp_updated_at: "Wednesday, 22 Jan 2014, 15:23",
                                                           erp_vatline: 20,
                                                           infinite: true,
                                                           just_imported: true,
                                                           name_de: "zweites Inventar",
                                                           name_en: "second inventory",
                                                           number: "slipper-42",
                                                           recid: @product.inventories[1].id,
                                                           size: "42",
                                                           storage: "DG",
                                                           unit: "Stk.",
                                                           weight: "0.5" } ],
                                               status: "success",
                                               total: 2 }.to_json)
      end
    end


    describe "POST #manage_inventory" do
      context "read record" do
        it "reads the right inventory" do
          post :manage_inventory, cmd: "get-record", recid: @inventory.id, format: :text
          expect(assigns(:inventory)).to eql @inventory
        end

        it "returns the correct json" do
          post :manage_inventory, cmd: "get-record", recid: @inventory.id, format: :text
          expect(response.body).to be_json_eql({ record: { alternative_number: "slipper-4-2",
                                                           amount: "12.0",
                                                           charge: "ABC42",
                                                           comment_de: "in 3 Wochen lieferbar",
                                                           comment_en: "available in 3 weeks",
                                                           delivery_time: "2 Wochen",
                                                           erp_article_group: 17,
                                                           erp_characteristic_flag: 42,
                                                           erp_provision_code: 42,
                                                           erp_updated_at: "Wednesday, 22 Jan 2014, 15:23",
                                                           erp_vatline: 20,
                                                           infinite: true,
                                                           just_imported: true,
                                                           name_de: "Halbschuh Größe 37",
                                                           name_en: "Slipper Size 8",
                                                           number: "slipper-42",
                                                           product_id: @product.id,
                                                           recid: assigns(:inventory).id,
                                                           size: "42",
                                                           storage: "DG",
                                                           unit: "Stk.",
                                                           weight: "0.5" },
                                                 status: "success"}.to_json )
        end
      end


      context "edit record" do
        before :each do
          @attrs = { format: :text,
                     cmd: "save-record",
                     recid: @inventory.id.to_s,
                     record: { recid: @inventory.id.to_s,
                               name_de: "geänderter Name",
                               name_en: "changed name",
                               number: "geänderte Nummer",
                               amount: "17",
                               unit: "Teile",
                               comment_de: "geänderter Kommentar",
                               comment_en: "changed comment",
                               weight: "12",
                               size: "geänderte Größe",
                               charge: "geänderte Charge",
                               storage: "neuer Lagerort",
                               delivery_time: { id: "1 Woche",
                                                text: "1 Woche" },
                               erp_updated_at: "Di, 9.Sep 14, 18:36",
                               erp_vatline: "2",
                               erp_article_group: "80",
                               erp_provision_code: "1",
                               erp_characteristic_flag: "1",
                               infinite: "0",
                               just_imported: "false",
                               alternative_number: "changed alternative number",
                               product_id: @product.id.to_s } }
        end

        it "reads the right inventory" do
          post :manage_inventory, @attrs
          expect(assigns(:inventory)).to eql @inventory
        end

        it "updates the attributes accordingly" do
          post :manage_inventory, @attrs
          expect(assigns(:inventory).name_de).to eql "geänderter Name"
          expect(assigns(:inventory).name_en).to eql "changed name"
          expect(assigns(:inventory).number).to eql "geänderte Nummer"
          expect(assigns(:inventory).alternative_number).to eql "changed alternative number"
          expect(assigns(:inventory).amount).to eql 17
          expect(assigns(:inventory).unit).to eql "Teile"
          expect(assigns(:inventory).comment_de).to eql "geänderter Kommentar"
          expect(assigns(:inventory).comment_en).to eql "changed comment"
          expect(assigns(:inventory).weight).to eql 12
          expect(assigns(:inventory).size).to eql "geänderte Größe"
          expect(assigns(:inventory).charge).to eql "geänderte Charge"
          expect(assigns(:inventory).storage).to eql "neuer Lagerort"
          expect(assigns(:inventory).delivery_time).to eql "1 Woche"
          expect(assigns(:inventory).infinite).to eql false
          expect(assigns(:inventory).product_id).to eql @product.id
        end

        it "returns the correct json" do
          post :manage_inventory, @attrs
          expect(response.body).to be_json_eql({ record: { alternative_number: "changed alternative number",
                                                           amount: "17.0",
                                                           charge: "geänderte Charge",
                                                           comment_de: "geänderter Kommentar",
                                                           comment_en: "changed comment",
                                                           delivery_time: "1 Woche",
                                                           erp_article_group: 17,
                                                           erp_characteristic_flag: 42,
                                                           erp_provision_code: 42,
                                                           erp_updated_at: "Wednesday, 22 Jan 2014, 15:23",
                                                           erp_vatline: 20,
                                                           infinite: false,
                                                           just_imported: true,
                                                           name_de: "geänderter Name",
                                                           name_en: "changed name",
                                                           number: "geänderte Nummer",
                                                           product_id: @product.id,
                                                           recid: assigns(:inventory).id,
                                                           size: "geänderte Größe",
                                                           storage: "neuer Lagerort",
                                                           unit: "Teile",
                                                           weight: "12.0" },
                                                 status: "success" }.to_json)
        end
      end


      context "create record" do
        before :each do
          @attrs =  { format: :text,
                      cmd: "save-record",
                      recid: "0",
                      record: { product_id: @product.id.to_s,
                                name_de: "Name",
                                name_en: "name",
                                number: "number",
                                comment_de: "Kommentar",
                                comment_en: "comment",
                                alternative_number: "alternative number",
                                infinite: "1",
                                amount: "33",
                                unit: "pc.",
                                weight: "22",
                                size: "Größe",
                                charge: "Charge",
                                storage: "Lagerort",
                                delivery_time: { id: "2-4 Tage",
                                                 text: "2-4 Tage"} } }
        end

        it "creates a new inventory" do
          post :manage_inventory, @attrs
          expect(assigns(:inventory)).to be_a Inventory
        end

        it "updates the attributes accordingly" do
          post :manage_inventory, @attrs
          expect(assigns(:inventory).name_de).to eql "Name"
          expect(assigns(:inventory).name_en).to eql "name"
          expect(assigns(:inventory).number).to eql "number"
          expect(assigns(:inventory).alternative_number).to eql "alternative number"
          expect(assigns(:inventory).amount).to eql 33
          expect(assigns(:inventory).unit).to eql "pc."
          expect(assigns(:inventory).comment_de).to eql "Kommentar"
          expect(assigns(:inventory).comment_en).to eql "comment"
          expect(assigns(:inventory).weight).to eql 22
          expect(assigns(:inventory).size).to eql "Größe"
          expect(assigns(:inventory).charge).to eql "Charge"
          expect(assigns(:inventory).storage).to eql "Lagerort"
          expect(assigns(:inventory).delivery_time).to eql "2-4 Tage"
          expect(assigns(:inventory).infinite).to eql true
          expect(assigns(:inventory).product_id).to eql @product.id
        end

        it "returns the correct json" do
          post :manage_inventory, @attrs
          expect(response.body).to be_json_eql({ record: { alternative_number: "alternative number",
                                                           amount: "33.0",
                                                           charge: "Charge",
                                                           comment_de: "Kommentar",
                                                           comment_en: "comment",
                                                           delivery_time: "2-4 Tage",
                                                           erp_article_group: nil,
                                                           erp_characteristic_flag: nil,
                                                           erp_provision_code: nil,
                                                           erp_updated_at: nil,
                                                           erp_vatline: nil,
                                                           infinite: true,
                                                           just_imported: nil,
                                                           name_de: "Name",
                                                           name_en: "name",
                                                           number: "number",
                                                           product_id: @product.id,
                                                           recid: assigns(:inventory).id,
                                                           size: "Größe",
                                                           storage: "Lagerort",
                                                           unit: "pc.",
                                                           weight: "22.0" },
                                                 status: "success" }.to_json)
        end
      end
    end


    describe "get #show_prices" do
      it "reads the right prices" do
        get :show_prices, id: @inventory.id
        expect(assigns(:prices)).to match_array @inventory.prices
      end

      it "returns the correct json" do
        get :show_prices, id: @product.id
        expect(response.body).to be_json_eql({ records: [{ promotion: true,
                                                           recid: @inventory.prices[0].id,
                                                           scale_from: "1.0",
                                                           scale_to: "6.0",
                                                           valid_from: "2012-01-01",
                                                           valid_to: "2113-01-01",
                                                           value: "42.0",
                                                           vat: "20.0" },
                                                         { promotion: true,
                                                           recid: @inventory.prices[1].id,
                                                           scale_from: "7.0",
                                                           scale_to: "100.0",
                                                           valid_from: "2012-01-01",
                                                           valid_to: "2113-01-01",
                                                           value: "38.0",
                                                           vat: "10.0"} ],
                                               status: "success",
                                               total: 2 }.to_json)
      end
    end


    describe "POT #manage_price" do
      context "read record" do
        it "reads the right price" do
          post :manage_price, cmd: "get-record", recid: @price.id, format: :text
          expect(assigns(:price)).to eql @price
        end

        it "returns the correct json" do
          post :manage_price, cmd: "get-record", recid: @price.id, format: :text
          expect(response.body).to be_json_eql({ record: { inventory_id: @inventory.id,
                                                           promotion: true,
                                                           recid: @price.id,
                                                           scale_from: "1.0",
                                                           scale_to: "6.0",
                                                           valid_from: "2012-01-01",
                                                           valid_to: "2113-01-01",
                                                           value: "42.0",
                                                           vat: "20.0" },
                                                 status: "success"}.to_json )
        end
      end


      context "edit record" do
        before :each do
          @attrs = { format: :text,
                     cmd:"save-record",
                     recid: @price.id.to_s,
                     record:{ recid: @price.id.to_s,
                              value: "88",
                              vat: "21",
                              valid_from: "04.09.2014",
                              valid_to: "10.09.2014",
                              scale_from: "1",
                              scale_to: "2",
                              promotion: "1",
                              inventory_id: @inventory.id.to_s } }
        end

        it "reads the right product" do
          post :manage_price, @attrs
          expect(assigns(:price)).to eql @price
        end

        it "updates the attributes accordingly" do
          post :manage_price, @attrs
          expect(assigns(:price).value).to eql 88
          expect(assigns(:price).vat).to eql 21
          expect(assigns(:price).valid_from).to eql Date.new(2014, 9, 4)
          expect(assigns(:price).valid_to).to eql Date.new(2014, 9, 10)
          expect(assigns(:price).scale_from).to eql 1
          expect(assigns(:price).scale_to).to eql 2
          expect(assigns(:price).promotion).to eql true
          expect(assigns(:price).inventory_id).to eql @inventory.id
        end

        it "returns the correct json" do
          post :manage_price, @attrs
          expect(response.body).to be_json_eql({ record: { inventory_id: @inventory.id,
                                                           promotion: true,
                                                           recid: @price.id,
                                                           scale_from: "1.0",
                                                           scale_to: "2.0",
                                                           valid_from: "2014-09-04",
                                                           valid_to: "2014-09-10",
                                                           value: "88.0",
                                                           vat: "21.0" },
                                                 status: "success" }.to_json)
        end
      end


      context "create record" do
        before :each do
          @attrs =  { format: :text,
                      cmd: "save-record",
                      recid: "0",
                      record: { inventory_id: @inventory.id.to_s,
                                value: "8",
                                vat: "9",
                                valid_from: "03.06.2015",
                                valid_to: "05.06.2015",
                                scale_from: "5",
                                scale_to: "6",
                                promotion: "1" } }
        end

        it "creates a new product" do
          post :manage_price, @attrs
          expect(assigns(:price)).to be_a Price
        end

        it "updates the attributes accordingly" do
          post :manage_price, @attrs
          expect(assigns(:price).value).to eql 8
          expect(assigns(:price).vat).to eql 9
          expect(assigns(:price).valid_from).to eql Date.new(2015, 6, 3)
          expect(assigns(:price).valid_to).to eql Date.new(2015, 6, 5)
          expect(assigns(:price).scale_from).to eql 5
          expect(assigns(:price).scale_to).to eql 6
          expect(assigns(:price).promotion).to eql true
          expect(assigns(:price).inventory_id).to eql @inventory.id
        end

        it "returns the correct json" do
          post :manage_price, @attrs
          expect(response.body).to be_json_eql({ record: { inventory_id: @inventory.id,
                                                           promotion: true,
                                                           recid: assigns(:price).id,
                                                           scale_from: "5.0",
                                                           scale_to: "6.0",
                                                           valid_from: "2015-06-03",
                                                           valid_to: "2015-06-05",
                                                           value: "8.0",
                                                           vat: "9.0" },
                                                 status: "success" }.to_json)
        end
      end
    end


    describe "DELETE #delete_price" do
      it "finds the right price" do
        post :delete_price, id: @price.id
        expect(assigns(:price)).to eql @price
      end

      it "deletes the price" do
        post :delete_price, id: @price.id
        expect(Price.where(id: @price.id)).to be_empty
      end

      it "renders nothing" do
        post :delete_price, id: @price.id
        expect(response.body).to eql(" ")
      end
    end


    describe "DELETE #delete_inventory" do
      context "no prices" do
        before :each do
          @inventory.prices.delete_all
        end

        it "finds the right inventory" do
          post :delete_inventory, id: @inventory.id
          expect(assigns(:inventory)).to eql @inventory
        end

        it "deletes the inventory, if there are no prices" do
          post :delete_inventory, id: @inventory.id
          expect(Inventory.where(id: @inventory.id)).to be_empty
        end

        it "renders nothing, if there are no prices" do
          post :delete_inventory, id: @inventory.id
          expect(response.body).to eql(" ")
        end
      end

      context "with prices" do
        it "leaves the inventory, if there are prices" do
          post :delete_inventory, id: @inventory.id
          expect(Inventory.find(@inventory.id)).to eql @inventory
        end

        it "redirects 403, if there are prices" do
          post :delete_inventory, id: @inventory.id
          expect(response).to have_http_status(403)
        end
      end
    end


    describe "GET import_icecat" do
      it "reads the right product" do
        allow_any_instance_of(Product).to receive(:update_from_icecat) {true}
        get :import_icecat, id: @product.id
        expect(assigns(:product)).to eql @product
      end

      it "calls the right method" do
        allow_any_instance_of(Product).to receive(:update_from_icecat) {true}
        expect_any_instance_of(Product).to receive(:update_from_icecat)
        get :import_icecat, id:  @product.id
      end

      it "redirects 403, if product could not be updated" do
        allow_any_instance_of(Product).to receive(:update_from_icecat) {false}
        expect_any_instance_of(Product).to receive(:update_from_icecat)

        get :import_icecat, id:  @product.id
        expect(response).to have_http_status(403)
      end
    end
  end
end