require 'spec_helper'

describe Contracting::TonersController, :type => :controller do

  context "crud actions" do
    before :each do
      no_redirects and act_as_admin

      @instance = create(:toner)
      @invalid_attributes = attributes_for(:toner, vendor_number: nil)
    end

    it_behaves_like("crud actions")
  end


  describe "PUT #do_upload" do
    before :each do
      no_redirects and act_as_admin
      @tonerliste = fixture_file_upload("#{Rails.root}/spec/factories/tonerliste.csv",
                                        "text/csv")
    end

    it "uploads an xls sheet" do
      put :do_upload, xls: @tonerliste
      expect(response).to have_http_status(200)
    end

    it "creates a toner record" do
      put :do_upload, xls: @tonerliste
      expect(Toner.all.count).to eql 1
      expect(Toner.first.article_number).to eql "1013351"
      expect(Toner.first.description).to eql "HP Toner schwarz HV LJ4 LJ4M LJ4+ HV"
      expect(Toner.first.price).to eql 0
    end
  end

  describe "grid index" do
    it "returns the correct json for all users" do
      no_redirects and act_as_admin
      @toner = create(:toner)
      @second_toner = create(:second_toner)

      get :grid_index
      expect(response.body).to be_json_eql({ records: [ { article_number: "TR0815",
                                                          description: "Toner schwarz",
                                                          price: "42.15",
                                                          recid: @toner.id,
                                                          vendor_number: "HP-TR0815" },
                                                        { article_number: "TY0816",
                                                          description: "Toner gelb",
                                                          price: "12.0",
                                                          recid: @second_toner.id,
                                                          vendor_number: "HP-TR0816" } ],
                                             status: "success",
                                             total: 2 }.to_json)
    end
  end
end