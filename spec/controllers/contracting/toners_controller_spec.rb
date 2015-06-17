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
end