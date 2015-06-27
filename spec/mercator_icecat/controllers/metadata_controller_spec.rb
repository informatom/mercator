require 'spec_helper'

describe Admin::MetadataController, :type => :controller do

  context "crud actions" do
    before :each do
      no_redirects and act_as_admin

      @instance = create(:metadatum)
      @invalid_attributes = attributes_for(:metadatum, path: nil)
    end

    it_behaves_like("crud actions")
  end

  context "setup" do
    it "knows its model" do
      expect(Admin::MetadataController.model).to eql MercatorIcecat::Metadatum
    end
  end
end