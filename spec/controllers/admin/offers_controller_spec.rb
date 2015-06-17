require 'spec_helper'

describe Admin::OffersController, :type => :controller do

  context "crud actions" do
    before :each do
      no_redirects and act_as_admin

      @instance = create(:offer)
      @invalid_attributes = attributes_for(:offer, valid_until: nil)
    end

    it_behaves_like("crud except destroy")

    describe 'DELETE #destroy' do
      it "redirects to #index" do
        delete :destroy, id: @instance
        expect(response).to redirect_to admin_offers_path
      end
    end
  end
end