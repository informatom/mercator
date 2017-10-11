require 'spec_helper'

describe Contracting::UsersController, :type => :controller do

  context "crud actions" do
    before :each do
      no_redirects and act_as_sales

      @instance = create(:user)
      @invalid_attributes = attributes_for(:user, email_address: nil)
    end

    it_behaves_like("crud except destroy")

    describe "grid index" do
      it "returns the correct json for all users" do
        get :grid_index
        expect(response.body).to be_json_eql({ records: [{ administrator: false,
                                                           call_priority: nil,
                                                           contentmanager: false,
                                                           editor: nil,
                                                           email_address: "another.sales.consultant@informatom.com",
                                                           erp_account_nr: "a123",
                                                           erp_contact_nr: "b123",
                                                           first_name: "Sammy",
                                                           gender: "male",
                                                           gtc_confirmed_at: "2014-01-22T15:23:00.000+01:00",
                                                           gtc_version_of: "2014-01-22",
                                                           last_login_at: "2014-01-22T15:23:00.000+01:00",
                                                           locale: "en",
                                                           logged_in: false,
                                                           login_count: 0,
                                                           phone: nil,
                                                           productmanager: false,
                                                           recid: @sales.id,
                                                           sales: true,
                                                           sales_manager: false,
                                                           surname: "Sales Representative",
                                                           title: "Dr",
                                                           waiting: nil },
                                                         { administrator: false,
                                                           call_priority: nil,
                                                           contentmanager: false,
                                                           editor: nil,
                                                           email_address: "john.doe@informatom.com",
                                                           erp_account_nr: "a123",
                                                           erp_contact_nr: "b123",
                                                           first_name: "John",
                                                           gender: "male",
                                                           gtc_confirmed_at: "2014-01-22T15:23:00.000+01:00",
                                                           gtc_version_of: "2014-01-22",
                                                           last_login_at: "2014-01-22T15:23:00.000+01:00",
                                                           locale: nil,
                                                           logged_in: false,
                                                           login_count: 0,
                                                           phone: nil,
                                                           productmanager: false,
                                                           recid: @instance.id,
                                                           sales: false,
                                                           sales_manager: false,
                                                           surname: "Doe",
                                                           title: "Dr",
                                                           waiting: nil } ],
                                               status: "success",
                                               total: 2 }.to_json)
      end

      it "returns the correct json for only consultants" do
        get :grid_index, only_consultants: "true"
        expect(response.body).to be_json_eql({ records: [{ administrator: false,
                                                           call_priority: nil,
                                                           contentmanager: false,
                                                           editor: nil,
                                                           email_address: "another.sales.consultant@informatom.com",
                                                           erp_account_nr: "a123",
                                                           erp_contact_nr: "b123",
                                                           first_name: "Sammy",
                                                           gender: "male",
                                                           gtc_confirmed_at: "2014-01-22T15:23:00.000+01:00",
                                                           gtc_version_of: "2014-01-22",
                                                           last_login_at: "2014-01-22T15:23:00.000+01:00",
                                                           locale: "en",
                                                           logged_in: false,
                                                           login_count: 0,
                                                           phone: nil,
                                                           productmanager: false,
                                                           recid: @sales.id,
                                                           sales: true,
                                                           sales_manager: false,
                                                           surname: "Sales Representative",
                                                           title: "Dr",
                                                           waiting: nil }],
                                               status: "success",
                                               total: 1 }.to_json)
      end
    end


    describe "mesonic grid index" do
      it "returns the correct json" do
        get :mesonic_grid_index
        expect(response.body).to be_json_eql( "success".to_json).at_path("status")
        expect(response.body).to be_json_eql({ account: "030401",
                                               detail: "research & business development GmbH",
                                               name: "CONNEXIO - ALL.IN.PRINT",
                                               recid: 0 }.to_json).at_path("records/0")
      end
    end
  end
end