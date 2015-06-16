require 'spec_helper'

describe User do
  it "is valid with a first_name, surname, email_address, last_login_at, gtc_confirmed_at,
      gtc_version_of, erp_account_nr, erp_contact_nr but without administrator" do
    expect(build :user).to be_valid
  end

  it {should validate_presence_of :surname}
  it {should validate_presence_of :email_address}

  it {should validate_uniqueness_of :email_address}

  it {should have_many :addresses}
  it {should have_many :billing_addresses}
  it {should have_many :orders}
  it {should have_many :offers}
  it {should have_many :comments}
  it {should have_many :conversations}

  it "is valid with a name, email_address and administrator" do
    expect(build :admin).to be_valid
  end

  it "is valid with a name, email_address and sales" do
    expect(build :sales).to be_valid
  end

  it "is valid with a name, email_address and sales manager" do
    expect(build :salesmanager).to be_valid
  end

  it "is versioned" do
    is_expected.to respond_to :versions
  end

  it "has a photo attached" do
    is_expected.to respond_to :photo
  end


  #--- Instance Methods ---#


  context "signed_up?" do
    it "returns true, if state is active" do
      @user = create(:user, state: "active")
      expect(@user.signed_up?).to eql true
    end

    it "returns true, if state is inactive" do
      @user = create(:user, state: "inactive")
      expect(@user.signed_up?).to eql false
    end
  end


  context "name" do
    it "returns the name" do
      @user = create(:user, state: "active")
      expect(@user.name).to eql "Mr. John Doe"
    end
  end


  context "gtc_accepted_current?" do
    before :each do
      create(:older_gtc)
      @current_gtc = create(:newer_gtc)
      @user = create(:user)
    end

    it "returns false if the accepted gtc isn't the current one" do
      expect(@user.gtc_accepted_current?).to eql false
    end

    it "returns true if the accepted gtc is the current one" do
      @user.update(gtc_version_of: @current_gtc.version_of)
      expect(@user.gtc_accepted_current?).to eql true
    end
  end


  context "basket" do
    before :each do
      @user = create(:user)
    end

    it "returns a new basket if none existant" do
      expect(@user.basket.state.to_s).to eql "basket"
    end

    it "returns the existant basket, if there is one" do
      @basket = @user.basket
      expect(@user.basket).to eql @basket
    end
  end


  context "parked_basket" do
    before :each do
      @user = create(:user)
      @parked_basket = create(:order, user: @user,
                                      state: "parked")
      @lineitem = create(:lineitem, order: @parked_basket)
      @absolete_parked_basket = create(:order, user: @user,
                                               state: "parked")
      @admin = create(:admin)
      allow(@absolete_parked_basket).to receive(:acting_user) { @admin }

      create(:constant_shipping_cost)
      create(:shipping_cost_article)
    end

    it "returns parked basket" do
      expect(@user.parked_basket).to eql @parked_basket
    end

    it "cleans up parked baskets" do
      @user.parked_basket
      expect(Order.exists?(@absolete_parked_basket)).to eql false
    end
  end


  context "sync_agb_with_basket" do
    before :each do
      @older_gtc = create(:older_gtc)
      @newer_gtc = create(:newer_gtc)
    end

    it "updates basket version if user version is newer" do
      @user = create(:user, gtc_version_of: @newer_gtc.version_of)
      @basket = create(:order, gtc_version_of: @older_gtc.version_of,
                               state: "basket",
                               user: @user)
      @user.sync_agb_with_basket
      @basket.reload
      expect(@basket.gtc_version_of).to eql @newer_gtc.version_of
    end

    it "updates user version if basket version is newer" do
      @user = create(:user, gtc_version_of: @older_gtc.version_of)
      @basket = create(:order, gtc_version_of: @newer_gtc.version_of,
                               state: "basket",
                               user: @user)
      @user.sync_agb_with_basket
      expect(@user.gtc_version_of).to eql @newer_gtc.version_of
    end
  end


  context "call_for_chat_partner" do
    it "returns nil if no consultant is logged in" do
      @user = create(:user, waiting: true)
      @robot = create(:robot)
      User.send(:remove_const, :ROBOT) # just to avoid warning in the next line
      User::ROBOT = @robot

      expect(@user.call_for_chat_partner(locale: "en")).to eql "message sent"
    end

    context "if consultants or logged in" do
      before :each do
        @user = create(:user)
        @robot = create(:robot)
        User.send(:remove_const, :ROBOT) # just to avoid warning in the next line
        User::ROBOT = @robot

        @consultant = create(:sales, logged_in: true)
        @second_consultant = create(:sales, logged_in: true,
                                            email_address: "second_consultant@informatom.com")
        @third_consultant = create(:sales, logged_in: true,
                                           email_address: "third_consultant@informatom.com")
        @fourth_consultant = create(:sales, logged_in: true,
                                            email_address: "fourth_consultant@informatom.com")
        @fifth_consultant = create(:sales, logged_in: true,
                                           email_address: "fifth_consultant@informatom.com")
      end

      it "tries five times to get a consultant to respond" do
        @user.update(waiting: true)
        expect(PrivatePub).to receive(:publish_to).with("/0004/personal/" + @consultant.id.to_s,
                                                        sender: @robot.name,
                                                        content: "Can you pick up a new video chat?",
                                                        video_channel_id: @user.id)
        expect(PrivatePub).to receive(:publish_to).with("/0004/personal/" + @second_consultant.id.to_s,
                                                        sender: @robot.name,
                                                        content: "Can you pick up a new video chat?",
                                                        video_channel_id: @user.id)
        expect(PrivatePub).to receive(:publish_to).with("/0004/personal/" + @third_consultant.id.to_s,
                                                        sender: @robot.name,
                                                        content: "Can you pick up a new video chat?",
                                                        video_channel_id: @user.id)
        expect(PrivatePub).to receive(:publish_to).with("/0004/personal/" + @fourth_consultant.id.to_s,
                                                        sender: @robot.name,
                                                        content: "Can you pick up a new video chat?",
                                                        video_channel_id: @user.id)
        expect(PrivatePub).to receive(:publish_to).with("/0004/personal/" + @fifth_consultant.id.to_s,
                                                        sender: @robot.name,
                                                        content: "Can you pick up a new video chat?",
                                                        video_channel_id: @user.id)
        expect(PrivatePub).to receive(:publish_to).with("/0004/personal/" + @user.id.to_s,
                                                        sender: @robot.name,
          content: "Unfortunately, we have no sales representative available for you right now. Please try later or stay at this page.")
        @user.call_for_chat_partner(locale: "en")
      end

      it "trues only once if call is picked up (that is @user.waiting: false)" do
        expect(PrivatePub).to receive(:publish_to).with("/0004/personal/" + @consultant.id.to_s,
                                                        sender: @robot.name,
                                                        content: "Can you pick up a new video chat?",
                                                        video_channel_id: @user.id)
        expect(PrivatePub).not_to receive(:publish_to).with("/0004/personal/" + @second_consultant.id.to_s,
                                                        sender: @robot.name,
                                                        content: "Can you pick up a new video chat?",
                                                        video_channel_id: @user.id)
        @user.call_for_chat_partner(locale: "en")
      end
    end
  end


  #--- Class Methods --- #

  context "initialize" do
    it "creates a user" do
      expect{User.initialize}.to change{User.count}.by 1
    end

    it "set the user's surname " do
      @user = User.initialize
      expect(@user.surname).to eql "Gast"
    end

    it "sets the user's email " do
      @user = User.initialize
      expect(@user.email_address).to include "mercator.informatom.com"
    end

    it "creates a user key" do
      @user = User.initialize
      expect(@user.lifecycle.key).not_to eql nil
    end
  end


  context "assign_consultant" do
    it "assigns a consultant that is logged_in" do
      @consultant = create(:sales, logged_in: true)
      expect(User.assign_consultant).to eql @consultant
    end

    it "assigns a consultant that is logged_in according to position" do
      @consultant = create(:sales, logged_in: true)
      @another_consultant = create(:sales, logged_in: true,
                                           email_address: "another_consultant@informatom.com")
      expect(User.assign_consultant(position: 1)).to eql @another_consultant
    end
  end


  context "mesoprim" do
    it "returns mesoprim" do
      expect(User.mesoprim(number: "test")).to eql "test-2004-1380"
    end
  end


  context "cleanup_deprecated" do
    it "deletes a deprecated user" do
      @user = User.initialize()
      @user.save
      @user.update(created_at: Time.now - 5.hours)
      expect{User.cleanup_deprecated}.to change{User.count}.by -1
    end

    it "leaves a user with an order untouched" do
      @user = User.initialize()
      @user.save
      @user.update(created_at: Time.now - 5.hours)
      order = create(:order, user: @user)
      expect{User.cleanup_deprecated}.not_to change{User.count}
    end

    it "leaves a user with a surname" do
      @user = User.initialize()
      @user.save
      @user.update(created_at: Time.now - 5.hours,
                   surname: "Mustermann")
      expect{User.cleanup_deprecated}.not_to change{User.count}
    end

    it "leaves a user with confirmed gtc" do
      @user = User.initialize()
      @user.save
      @user.update(created_at: Time.now - 5.hours,
                   gtc_confirmed_at: Date.today)
      expect{User.cleanup_deprecated}.not_to change{User.count}
    end

    it "leaves a user younger than 1 hour" do
      @user = User.initialize()
      @user.save
      expect{User.cleanup_deprecated}.not_to change{User.count}
    end


    it "leaves an active user with an order untouched" do
      @user = create(:user)
      expect{User.cleanup_deprecated}.not_to change{User.count}
    end
  end


  context "no_sales_logged_in" do
    it 'duos not send email if consultant is logged in' do
      @consultant = create(:sales, logged_in: true)
      expect(UserMailer).not_to receive(:consultant_missing)
      User.no_sales_logged_in
    end

    it "sends email if no consultant is logged in" do
      expect(UserMailer).to receive(:consultant_missing).and_return( double("OrderMailer", :deliver => true))
      User.no_sales_logged_in
    end
  end
end
