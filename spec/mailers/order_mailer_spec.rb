require 'spec_helper'

describe OrderMailer do
  before :each do
    @user = create(:user)
    @order = create(:order, user_id: @user.id)
    @service_mail = create(:constant_service_mail).value
  end

  describe "confirmation" do
    before :each do
      @order_corfirmation_mail_subject = create(:constant_order_confirmation_mail_subject).value
      @mail = OrderMailer.confirmation(order: @order)
    end

    it "has to set" do
      expect(@mail).to deliver_to "john.doe@informatom.com"
    end

    it "has from set" do
      expect(@mail).to deliver_from @service_mail
    end

    it "has subject" do
      expect(@mail).to have_subject @order_corfirmation_mail_subject
    end

    it "has bcc set" do
      expect(@mail).to bcc_to @service_mail
    end
  end


  describe "notify_in_payment" do
    before :each do
      @order_notify_in_payment_mail_subject = create(:constant_order_notify_in_payment_mail_subject).value
      @mail = OrderMailer.notify_in_payment([@order])
    end

    it "has to set" do
      expect(@mail).to deliver_to @service_mail
    end

    it "has from set" do
      expect(@mail).to deliver_from @service_mail
    end

    it "has subject" do
      expect(@mail).to have_subject @order_notify_in_payment_mail_subject
    end
  end
end