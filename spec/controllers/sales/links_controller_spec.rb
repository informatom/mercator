require 'spec_helper'

describe Sales::LinksController, :type => :controller do

  describe "crud actions" do
    before :each do
      no_redirects and act_as_sales

      @conversation = create(:conversation)
      @instance = create(:link, conversation: @conversation)
    end

    it_behaves_like("crud show index new edit")
    it_behaves_like("crud destroy")


    describe 'PATCH #update' do
      it "with data it redirects to #show" do
        patch :update, id: @instance,
                       link: attributes_for(:link, title: "new title")
        expect(response).to redirect_to(sales_link_path(assigns(:link)))
      end
    end


    describe 'POST #create' do
      it "with data it redirects to #show" do
        post :create, link: attributes_for(:link, conversation_id: @conversation.id)
        expect(response).to redirect_to(sales_link_path(assigns(:link)))
      end

      it "removes a remember token" do
        post :create, link: attributes_for(:link, conversation_id: @conversation.id,
                                                  url: "http://informatom.com/some/path?remember_token=dangerous&other_params=ok")
        expect(assigns(:link).url).to eql("http://informatom.com/some/path?other_params=ok")
      end

      it "adds http if missing" do
        post :create, link: attributes_for(:link, conversation_id: @conversation.id,
                                                  url: "informatom.com")
        expect(assigns(:link).url).to eql("http://informatom.com")
      end

      it "publishes links" do
        expect(PrivatePub).to receive(:publish_to).with("/0004/conversations/"+ @conversation.id.to_s,
                                                        type: "links",
                                                        url: "http://www.informatom.com")
        post :create, link: attributes_for(:link, conversation_id: @conversation.id)
      end
    end
  end
end
