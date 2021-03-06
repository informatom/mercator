require 'spec_helper'

describe LinksController, :type => :controller do

  context "crud actions" do
    before :each do
      no_redirects and act_as_sales

      @conversation = create(:conversation)
      @instance = create(:link, conversation: @conversation)
    end


    describe 'POST #create' do
      it "with data it redirects to #show" do
        post :create, link: attributes_for(:link, conversation_id: @conversation.id)
        expect(response).to redirect_to(links_path)
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
        expect(PrivatePub).to receive(:publish_to).with("/" + CONFIG[:system_id] + "/conversations/"+ @conversation.id.to_s,
                                                        type: "links",
                                                        url: "http://www.informatom.com")
        post :create, link: attributes_for(:link, conversation_id: @conversation.id)
      end
    end
  end
end