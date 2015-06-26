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
      expect(@mesonic_kontakte_stamm.c039[2..10].to_i > 20000).to eql true # checks konto number
      expect(@mesonic_kontakte_stamm.C061.to_i > 20000).to eql true # checks contact number
      expect(@mesonic_kontakte_stamm.c001).to eql "Doe" # checks user
    end

    it "creates a mesonic kontenstamm" do
      @user.push_to_mesonic
      expect(@user.instance_variable_get(:@mesonic_kontenstamm)).to be_a MercatorMesonic::Kontenstamm
    end

    it "sets the mesonic kontenstamm attributes" do
      @user.push_to_mesonic
      @mesonic_kontenstamm = @user.instance_variable_get(:@mesonic_kontenstamm)
      expect(Time.now - @mesonic_kontenstamm.c086 < 5.seconds).to eql true # checks timestamp
      expect(@mesonic_kontenstamm.c002.first(2)).to eql "1I"
      expect(@mesonic_kontenstamm.c002[2..10].to_i > 20000).to eql true # checks konto number
      expect(@mesonic_kontenstamm.c003.last(3)).to eql "Doe" # checks user
    end

    it "creates a mesonic kontenstamm_fakt" do
      @user.push_to_mesonic
      expect(@user.instance_variable_get(:@mesonic_kontenstamm_fakt)).to be_a MercatorMesonic::KontenstammFakt
    end

    it "sets the mesonic kontenstamm_fakt attributes" do
      @user.push_to_mesonic
      @mesonic_kontenstamm_fakt = @user.instance_variable_get(:@mesonic_kontenstamm_fakt)
      expect(@mesonic_kontenstamm_fakt.c112.first(2)).to eql "1I"
      expect(@mesonic_kontenstamm_fakt.c112[2..10].to_i > 20000).to eql true # checks konto number
      expect(@mesonic_kontenstamm_fakt.C187).to eql "john.doe@informatom.com" # checks email address
    end

    it "creates a mesonic kontenstamm_fibu" do
      @user.push_to_mesonic
      expect(@user.instance_variable_get(:@mesonic_kontenstamm_fibu)).to be_a MercatorMesonic::KontenstammFibu
    end

    it "sets the mesonic kontenstamm_fibu attributes" do
      @user.push_to_mesonic
      @mesonic_kontenstamm_fibu = @user.instance_variable_get(:@mesonic_kontenstamm_fibu)
      expect(@mesonic_kontenstamm_fibu.c104.first(2)).to eql "1I"
      expect(@mesonic_kontenstamm_fibu.c104[2..10].to_i > 20000).to eql true # checks konto number
    end

    it "creates a mesonic kontenstamm_adresse" do
      @user.push_to_mesonic
      expect(@user.instance_variable_get(:@mesonic_kontenstamm_adresse)).to be_a MercatorMesonic::KontenstammAdresse
    end

    it "sets the mesonic kontenstamm_adresse attributes" do
      @user.push_to_mesonic
      @mesonic_kontenstamm_adresse = @user.instance_variable_get(:@mesonic_kontenstamm_adresse)
      expect(@mesonic_kontenstamm_adresse.c001.first(2)).to eql "1I"
      expect(@mesonic_kontenstamm_adresse.c001[2..10].to_i > 20000).to eql true # checks konto number
      expect(@mesonic_kontenstamm_adresse.c050).to eql "Kärntner Straße 123" # checks billing address
    end

    it "updates erp account and contact number" do
      @user.push_to_mesonic
      expect(@user.erp_account_nr.first(2)).to eql "1I"
      expect(@user.erp_account_nr[2..10].to_i > 20000).to eql true
      expect(@user.erp_contact_nr > 20000).to eql true
    end
  end


  describe "update_mesonic" do
    it "finds a mesonic kontenstamm_adresse" do
      @user.update_mesonic
      expect(@user.instance_variable_get(:@mesonic_kontenstamm_adresse)).to be_a MercatorMesonic::KontenstammAdresse
    end
  end


  describe "mesonic_account_number" do
    it "returns the mesonic_account_number for users" do
      expect(@user.mesonic_account_number).to eql 691801
    end

    it "returns the mesonic_account_number for potential customers" do
      @user.update(erp_account_nr: "1I12345")
      expect(@user.mesonic_account_number).to eql 12345
    end
  end


  describe "update_erp_account_nr" do
    before :each do
      @user.update(erp_contact_nr: "10000-2004-1380",
                   erp_account_nr: nil)
    end

    it "finds a mesonic_kontenstamm" do
      @user.update_erp_account_nr
      expect(@user.instance_variable_get(:@mesonic_kontenstamm)).to be_a MercatorMesonic::Kontenstamm
    end

    it "fixes the erp account number" do
      @user.update_erp_account_nr
      expect(@user.erp_account_nr).to eql "112452-2004-1380"
    end
  end
end