require 'spec_helper'

describe ApplicationController, :type => :controller do

  describe "default_url_options" do
    it "return locale hash" do
      expect(controller.default_url_options).to eql({ locale: :en })
    end
  end


  describe "user_for_paper_trail" do
    it "returns the current user, if logged in" do
      act_as_user
      expect(controller.user_for_paper_trail).to eql @user
    end

    it "returns guest otherwise" do
      allow(controller).to receive(:logged_in?) { false }
      expect(controller.user_for_paper_trail).to eql "Guest"
    end
  end


  describe "current basket" do
    it "returns the current basket" do
      act_as_user
      @basket = @user.basket
      expect(controller.current_basket).to eql @basket
    end
  end


  describe "domain_cms_redirect" do
    before :each do
      create(:podcast_domain)
      Constant.send(:remove_const, :CMSDOMAIN) # just to avoid warning in the next line
      Constant::CMSDOMAIN = create(:cms_domain).value
      act_as_user
    end

    it "returns nil of url includes cms domain" do
      allow(controller).to receive_message_chain(:request, :url, :include?) { true }
      expect(controller.instance_eval{ domain_cms_redirect }).to eql nil
    end

    it "returns nil of url includes cms domain" do
      allow(controller).to receive_message_chain(:request, :url, :include?) { false }
      allow(controller).to receive_message_chain(:request, :url, :include?) { true }
      expect(controller.instance_eval{ domain_cms_redirect }).to eql nil
    end

    it "sets the new url for port 80" do
      allow(controller).to receive_message_chain(:request, :port) { 80 }
      allow(controller).to receive_message_chain(:request, :path) { "/some/path" }
      allow(controller).to receive_message_chain(:request, :url, :include?) { false }
      allow(controller).to receive(:redirect_to) { true }
      controller.instance_eval{ domain_cms_redirect }
      expect(assigns(:new_url)).to include "http://cms.domain.com/some/path?remember_token="
    end

    it "sets the new url for port 443" do
      allow(controller).to receive_message_chain(:request, :port) { 443 }
      allow(controller).to receive_message_chain(:request, :path) { "/some/path" }
      allow(controller).to receive_message_chain(:request, :url, :include?) { false }
      allow(controller).to receive(:redirect_to) { true }
      controller.instance_eval{ domain_cms_redirect }
      expect(assigns(:new_url)).to include "https://cms.domain.com/some/path?remember_token="
    end

    it "sets the new url for other ports (e.g. 3000)" do
      allow(controller).to receive_message_chain(:request, :port) { 3000 }
      allow(controller).to receive_message_chain(:request, :path) { "/some/path" }
      allow(controller).to receive_message_chain(:request, :url, :include?) { false }
      allow(controller).to receive(:redirect_to) { true }
      controller.instance_eval{ domain_cms_redirect }
      expect(assigns(:new_url)).to include "http://cms.domain.com:3000/some/path?remember_token="
    end

    it "sets remember me for user" do
      allow(controller).to receive_message_chain(:request, :port) { 80 }
      allow(controller).to receive_message_chain(:request, :path) { "/some/path" }
      allow(controller).to receive_message_chain(:request, :url, :include?) { false }
      allow(controller).to receive(:redirect_to) { true }
      controller.instance_eval{ domain_cms_redirect }
      @user.reload
      expect(@user.remember_token.length).to eql 40
    end
  end


  describe "domain_shop_redirect" do
    before :each do
      create(:podcast_domain)
      Constant.send(:remove_const, :SHOPDOMAIN) # just to avoid warning in the next line
      Constant::SHOPDOMAIN = create(:shop_domain).value
      act_as_user
    end

    it "returns nil of url includes shop domain" do
      allow(controller).to receive_message_chain(:request, :url, :include?) { true }
      expect(controller.instance_eval{ domain_shop_redirect }).to eql nil
    end

    it "returns nil of url includes shop domain" do
      allow(controller).to receive_message_chain(:request, :url, :include?) { false }
      allow(controller).to receive_message_chain(:request, :url, :include?) { true }
      expect(controller.instance_eval{ domain_shop_redirect }).to eql nil
    end

    it "sets the new url for port 80" do
      allow(controller).to receive_message_chain(:request, :port) { 80 }
      allow(controller).to receive_message_chain(:request, :path) { "/some/path" }
      allow(controller).to receive_message_chain(:request, :url, :include?) { false }
      allow(controller).to receive(:redirect_to) { true }
      controller.instance_eval{ domain_shop_redirect }
      expect(assigns(:new_url)).to include "http://shop.domain.com/some/path?remember_token="
    end

    it "sets the new url for port 443" do
      allow(controller).to receive_message_chain(:request, :port) { 443 }
      allow(controller).to receive_message_chain(:request, :path) { "/some/path" }
      allow(controller).to receive_message_chain(:request, :url, :include?) { false }
      allow(controller).to receive(:redirect_to) { true }
      controller.instance_eval{ domain_shop_redirect }
      expect(assigns(:new_url)).to include "https://shop.domain.com/some/path?remember_token="
    end

    it "sets the new url for other ports (e.g. 3000)" do
      allow(controller).to receive_message_chain(:request, :port) { 3000 }
      allow(controller).to receive_message_chain(:request, :path) { "/some/path" }
      allow(controller).to receive_message_chain(:request, :url, :include?) { false }
      allow(controller).to receive(:redirect_to) { true }
      controller.instance_eval{ domain_shop_redirect }
      expect(assigns(:new_url)).to include "http://shop.domain.com:3000/some/path?remember_token="
    end

    it "sets remember me for user" do
      allow(controller).to receive_message_chain(:request, :port) { 80 }
      allow(controller).to receive_message_chain(:request, :path) { "/some/path" }
      allow(controller).to receive_message_chain(:request, :url, :include?) { false }
      allow(controller).to receive(:redirect_to) { true }
      controller.instance_eval{ domain_shop_redirect }
      @user.reload
      expect(@user.remember_token.length).to eql 40
    end
  end
end