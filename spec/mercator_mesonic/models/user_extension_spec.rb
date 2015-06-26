require 'spec_helper'

describe User do
  before :each do
    @user = create(:user, erp_account_nr: "691801-2004-1380")
    create(:country)
    create(:billing_address, user_id: @user.id)
  end

  it {should belong_to :mesonic_kontakte_stamm}
  it {should belong_to :mesonic_kontenstamm}
  it {should belong_to :mesonic_kontenstamm_fakt}
  it {should belong_to :mesonic_kontenstamm_fibu}
  it {should belong_to :mesonic_kontenstamm_adresse}


  # --- Class Methods --- #

  describe "update_erp_account_nrs" do
    it "calls update_erp_account_nr for each user that is already connected" do
      expect_any_instance_of(User).to receive(:update_erp_account_nr)
      User.update_erp_account_nrs
    end
  end


  # --- Instance Methods --- #

  describe "push_to_mesonic" do
    it "creates a mesonic kontakte stamm" do
      @user.push_to_mesonic
      expect(@user.instance_variable_get(:@mesonic_kontakte_stamm)).to be_a MercatorMesonic::KontakteStamm
    end

    it "sets the mesonic kontakte stamm attributes" do
      @user.push_to_mesonic
      @mesonic_kontakte_stamm = @user.instance_variable_get(:@mesonic_kontakte_stamm)

      expect(@mesonic_kontakte_stamm.c005).to eql "Kärntner Straße 123" # checks billing_address
      expect(@mesonic_kontakte_stamm.c039.first(2)).to eql "1I"
      expect(@mesonic_kontakte_stamm.c039[2..10].to_i > 20000).to eql true # check konto number
      expect(@mesonic_kontakte_stamm.C061.to_i > 20000).to eql true # check contact number
      expect(@mesonic_kontakte_stamm.c001).to eql "Doe" # checks user
    end
  end
end