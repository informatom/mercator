require 'spec_helper'

describe Contracting::ConversationsController, :type => :controller do

  describe "grid index" do
    it "returns the correct json for all users" do
      @conversation = create(:conversation)
      create(:second_conversation, customer_id: @conversation.customer_id,
                                   consultant_id: @conversation.consultant_id)
      no_redirects and act_as_sales

      get :grid_index
      expect(response.body).to be_json_eql({ records: [ { consultant: "Mr. Dr Sammy Sales Representative",
                                                          customer: "Mr. Dr John Doe",
                                                          name: "Freudliche Beratung",
                                                          recid: 1 },
                                                        { consultant: "Mr. Dr Sammy Sales Representative",
                                                          customer: "Mr. Dr John Doe",
                                                          name: "Noch eine Konversation",
                                                          recid: 2 } ],
                                             status: "success",
                                             total: 2 }.to_json)
    end
  end
end