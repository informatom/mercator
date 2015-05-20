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


  context "sync_agb_with_basket", focus: true do
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

  #--- Class Methods --- #
end