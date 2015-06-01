require 'spec_helper'

describe Sales::DownloadsController, :type => :controller do

  describe "crud actions" do
    before :each do
      no_redirects and act_as_sales

      @conversation = create(:conversation)
      @instance = create(:download, conversation_id: @conversation.id)
      @invalid_attributes = attributes_for(:download, name: nil)
    end

    it_behaves_like("crud except create")


    describe 'POST #create' do
      it "with data it returns success = true" do
        post :create, download: attributes_for(:download)
        expect(response.body).to be_json_eql({ :success => "true" }.to_json)
      end

      it "publishes to downloads" do
        expect(PrivatePub).to receive(:publish_to).with("/0004/conversations/"+ @conversation.id.to_s,
                                                   type: "downloads")
        post :create, download: attributes_for(:download, conversation_id: @conversation.id)
      end

      it "moves to photo if document is a photo", focus: true do
        @photo = fixture_file_upload(Rails.root.to_s + '/spec/support/dummy_image.jpg', 'image/jpg')
        post :create, download: attributes_for(:download, photo: nil,
                                                          conversation_id: @conversation.id,
                                                          document: @photo)
        expect(assigns(:download).document.size).to eql nil # indeed! not 0!
        expect(assigns(:download).name).to eql "Ich bin ein Download"
      end

      it "stores document" do
        post :create, download: attributes_for(:download, photo: nil,
                                                          conversation_id: @conversation.id )
        expect(assigns(:download).photo.size).to eql nil # indeed! not 0!
        expect(assigns(:download).name).to eql "Ich bin ein Download"
      end
    end


    describe "DELETE #destroy" do
      it "publishes to downloads" do
        expect(PrivatePub).to receive(:publish_to).with("/0004/conversations/"+ @conversation.id.to_s,
                                                   type: "downloads")
        delete :destroy, id: @instance
      end
    end


    describe "PATCH #update" do
      it "publishes to downloads" do
        expect(PrivatePub).to receive(:publish_to).with("/0004/conversations/"+ @conversation.id.to_s,
                                                   type: "downloads")
        patch :update, id: @instance,
                       download: attributes_for(:download, conversation_id: @conversation.id)
      end
    end
  end
end