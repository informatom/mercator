require 'spec_helper'

describe OfferitemsController, :type => :controller do

  describe "lifecycle actions" do
    before :each do
      no_redirects and act_as_user

      @offer = create(:offer, complete: false,
                              state: "valid",
                              user_id: @user.id)
      @offeritem = create(:offeritem, offer_id: @offer.id,
                                      user_id: @user.id)
      @basket = create(:order, user_id: @user.id)

      request.env['HTTP_REFERER'] = order_path(@basket)
    end


    describe 'POST #do_copy' do
      it "creates a new lineitem in the basket with the carroect attributes" do
        put :do_copy, id: @offeritem.id
        expect(@basket.lineitems.count).to eql 1
        expect(@basket.lineitems.first.user_id).to eql @user.id
        expect(@basket.lineitems.first.position).to eql 10
        expect(@basket.lineitems.first.product_number).to eql "nr123"
        expect(@basket.lineitems.first.product_id).to eql @offeritem.product.id
        expect(@basket.lineitems.first.vat).to eql 20
        expect(@basket.lineitems.first.order_id).to eql @basket.id
        expect(@basket.lineitems.first.description_de).to eql "Artikel Eins Zwei Drei"
        expect(@basket.lineitems.first.description_en).to eql "Article One Two Three"
        expect(@basket.lineitems.first.amount).to eql 42
        expect(@basket.lineitems.first.product_price).to eql 123.45
        expect(@basket.lineitems.first.discount_abs).to eql 0
        expect(@basket.lineitems.first.value).to eql 5184.9
        expect(@basket.lineitems.first.unit).to eql "Stück"
        expect(@basket.lineitems.first.delivery_time).to eql "One week"
      end

      it "sets the flash message" do
        put :do_copy, id: @offeritem.id
        expect(flash[:success]).to eql "The offer position was copied into your current basket."
        expect(flash[:notice]).to eql nil
      end

      it "redirects to return_to" do
        put :do_copy, id: @offeritem.id
        expect(response).to redirect_to order_path(@basket)
      end
    end
  end
end