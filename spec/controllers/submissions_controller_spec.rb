require 'spec_helper'

describe SubmissionsController, :type => :controller do

  describe "crud actions" do
    before :each do
      no_redirects and act_as_user

      @instance = create(:submission)
      @invalid_attributes = attributes_for(:submission, answer: nil)
    end

    it_behaves_like("crud new")
    it_behaves_like("crud create")


    describe 'POST #create' do
      it "redirects to new_submission_path" do
        post :create, submission: attributes_for(:submission)
        expect(response).to redirect_to new_submission_path
      end

      it "sends mail" do
        expect(UserMailer).to receive(:new_submission).and_return( double("UserMailer", :deliver => true))
        post :create, submission: attributes_for(:submission)
      end
    end
  end
end