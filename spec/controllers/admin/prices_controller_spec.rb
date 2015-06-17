require 'spec_helper'

describe Admin::PricesController, :type => :controller do

  context "crud actions" do
    before :each do
      no_redirects and act_as_admin

      @instance = create(:price)
      @invalid_attributes = attributes_for(:price, value: nil)
    end

    it_behaves_like("crud actions")

    describe 'DELETE #destroy' do
      it "renders status success for json request" do
        xhr :delete, :destroy, id: @instance
        expect(response.body).to eql({status: "success" }.to_json)
      end
    end
  end
end