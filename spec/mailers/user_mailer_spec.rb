require 'spec_helper'

describe UserMailer do
  before :each do
    @user = create(:user)
  end

  describe "confirmation" do
    it "has to set" do
      expect(UserMailer.forgot_password(@user, "some key")).to deliver_to "john.doe@informatom.com"
    end

    it "has subject" do
      expect(UserMailer.forgot_password(@user, "some key")).to have_subject "Mercator " + "-- Passwort vergessen / forgotten password"
    end
  end


  describe "activation", focus: true do
    it "has to set" do
      expect(UserMailer.activation(@user, "some key")).to deliver_to "john.doe@informatom.com"
    end

    it "has subject" do
      expect(UserMailer.activation(@user, "some key")).to have_subject "Mercator -- E-Mail Verifizierung / email verification"
    end
  end


  describe "login_link" do
    it "has to set" do
      expect(UserMailer.login_link(@user, "some key")).to deliver_to "john.doe@informatom.com"
    end

    it "has subject" do
      expect(UserMailer.login_link(@user, "some key")).to have_subject "Mercator -- Login Link"
    end
  end


  describe "consultant_missing" do
    before :each do
      @service_mail = create(:constant_service_mail).value
    end

    it "has to set" do
      expect(UserMailer.consultant_missing).to deliver_to @service_mail
    end

    it "has subject" do
      expect(UserMailer.consultant_missing).to have_subject "Mercator -- Kein Vertriebsmitarbeiter angemeldet / no sales associate logged in"
    end
  end


  describe "new_submission" do
    before :each do
      @service_mail = create(:constant_service_mail).value
      @submission = create(:submission)
    end

    it "has to set" do
      expect(UserMailer.new_submission(@submission)).to deliver_to @service_mail
    end

    it "has subject" do
      expect(UserMailer.new_submission(@submission)).to have_subject "Mercator -- Neue Kontaktaufnahme"
    end
  end


  describe "new_comment" do
    before :each do
      @service_mail = create(:constant_service_mail).value
      @comment = create(:comment, user_id: @user.id)
    end

    it "has to set" do
      expect(UserMailer.new_comment(@comment)).to deliver_to @service_mail
    end

    it "has subject" do
      expect(UserMailer.new_comment(@comment)).to have_subject "Mercator -- Neuer Kommentar"
    end
  end
end