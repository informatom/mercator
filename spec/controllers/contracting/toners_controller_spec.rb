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
      @tonerliste = fixture_file_upload("#{Rails.root}/spec/factories/tonerliste.xlsx",
                                        "application/vnd.ms-excel")
    end

    it "uploads an xls sheet" do
      put :do_upload, xlsx: @tonerliste
      expect(response).to redirect_to contracting_toners_path
    end

    it "creates a toner record" do
      put :do_upload, xlsx: @tonerliste
      expect(Toner.all.count).to eql 1
      expect(Toner.first.vendor_number).to eql "Q6002A"
      expect(Toner.first.article_number).to eql "1076830"
      expect(Toner.first.description).to eql 'Toner Q6002A / gelb / bis zu 2000 Seiten / Color LaserJet 1600/2600/2605 Serie - "R"'
      expect(Toner.first.price).to eql 41.81
    end
  end
end