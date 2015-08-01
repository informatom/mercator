require 'spec_helper'

describe ApplicationController, :type => :controller do

  describe "default_url_options" do
    it "return locale hash" do
      I18n.locale = :en
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
      allow(controller).to receive(:redirect_to) { true } #"kills" redirect
      controller.instance_eval{ domain_cms_redirect }
      expect(assigns(:new_url)).to include "http://cms.domain.com/some/path?remember_token="
    end

    it "sets the new url for port 443" do
      allow(controller).to receive_message_chain(:request, :port) { 443 }
      allow(controller).to receive_message_chain(:request, :path) { "/some/path" }
      allow(controller).to receive_message_chain(:request, :url, :include?) { false }
      allow(controller).to receive(:redirect_to) { true } #"kills" redirect
      controller.instance_eval{ domain_cms_redirect }
      expect(assigns(:new_url)).to include "https://cms.domain.com/some/path?remember_token="
    end

    it "sets the new url for other ports (e.g. 3000)" do
      allow(controller).to receive_message_chain(:request, :port) { 3000 }
      allow(controller).to receive_message_chain(:request, :path) { "/some/path" }
      allow(controller).to receive_message_chain(:request, :url, :include?) { false }
      allow(controller).to receive(:redirect_to) { true } #"kills" redirect
      controller.instance_eval{ domain_cms_redirect }
      expect(assigns(:new_url)).to include "http://cms.domain.com:3000/some/path?remember_token="
    end

    it "sets remember me for user" do
      allow(controller).to receive_message_chain(:request, :port) { 80 }
      allow(controller).to receive_message_chain(:request, :path) { "/some/path" }
      allow(controller).to receive_message_chain(:request, :url, :include?) { false }
      allow(controller).to receive(:redirect_to) { true } #"kills" redirect
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
      allow(controller).to receive(:redirect_to) { true } #"kills" redirect
      controller.instance_eval{ domain_shop_redirect }
      expect(assigns(:new_url)).to include "http://shop.domain.com/some/path?remember_token="
    end

    it "sets the new url for port 443" do
      allow(controller).to receive_message_chain(:request, :port) { 443 }
      allow(controller).to receive_message_chain(:request, :path) { "/some/path" }
      allow(controller).to receive_message_chain(:request, :url, :include?) { false }
      allow(controller).to receive(:redirect_to) { true } #"kills" redirect
      controller.instance_eval{ domain_shop_redirect }
      expect(assigns(:new_url)).to include "https://shop.domain.com/some/path?remember_token="
    end

    it "sets the new url for other ports (e.g. 3000)" do
      allow(controller).to receive_message_chain(:request, :port) { 3000 }
      allow(controller).to receive_message_chain(:request, :path) { "/some/path" }
      allow(controller).to receive_message_chain(:request, :url, :include?) { false }
      allow(controller).to receive(:redirect_to) { true } #"kills" redirect
      controller.instance_eval{ domain_shop_redirect }
      expect(assigns(:new_url)).to include "http://shop.domain.com:3000/some/path?remember_token="
    end

    it "sets remember me for user" do
      allow(controller).to receive_message_chain(:request, :port) { 80 }
      allow(controller).to receive_message_chain(:request, :path) { "/some/path" }
      allow(controller).to receive_message_chain(:request, :url, :include?) { false }
      allow(controller).to receive(:redirect_to) { true } #"kills" redirect
      controller.instance_eval{ domain_shop_redirect }
      @user.reload
      expect(@user.remember_token.length).to eql 40
    end
  end


  describe "request_param" do
    it "returns nil if no parameter given" do
      expect(controller.instance_eval{ request_param(nil) }).to eql nil
    end

    it "parses the param out of the query, if given" do
      @query_string = "http://mercator.informatom.com/some/path?some_param=17&testparam=my_value"
      allow(controller).to receive_message_chain(:request, :query_string) { @query_string }
      expect(controller.instance_eval{ request_param(:testparam) }).to eql "my_value"
    end
  end


  describe "page_path_param" do
    it "returns nil if no parameter given" do
      expect(controller.instance_eval{ page_path_param(nil) }).to eql nil
    end

    it "parses the param out of the query, if given" do
      @query_string = "http://mercator.informatom.com/some/path?some_param=17&testparam=my_value"
      allow(controller).to receive(:params) { { page_path: @query_string } }
      expect(controller.instance_eval{ page_path_param(:testparam) }).to eql "my_value"
    end
  end


  describe "track_action" do
    it "tracks action" do
      expect(controller).to receive_message_chain(:ahoy, :track)
      expect(controller.instance_eval{ track_action }).to eql nil
    end
  end


  describe "allow_iframe" do
    it "tracks action" do
      expect(controller).to receive_message_chain(:response, :headers, :delete).with("X-Frame-Options")
      controller.instance_eval{ allow_iframe }
    end
  end


  describe "log_database_access" do
    it "tracks action" do
      controller.instance_eval{ log_database_access }
      expect(Rails.logger.level).to eql 0
    end
  end


  describe "auto_log_in" do
    context "no remember token" do
      it "sets current user from session" do
        @user = create(:user)
        session[:last_user] = @user.id
        allow(controller).to receive(:current_user).and_return(Guest.new(), @user)
        expect(controller).to receive_message_chain(:current_user=) { true }

        controller.instance_eval{ auto_log_in }
        expect(assigns(:current_user)).to eql @user
      end

      it "creates a new user, if we are guest" do
        @user = create(:user)
        session[:last_user] = @user.id
        allow(controller).to receive(:current_user).and_return(Guest.new(), @user)
        expect(controller).to receive_message_chain(:current_user=) { true }

        controller.instance_eval{ auto_log_in }
        expect(assigns(:current_user)).to be_a User
      end

      it "leaves current user unchanged, if not guest" do
        act_as_user
        controller.instance_eval{ auto_log_in }
        expect(controller.current_user).to eql @user
      end
    end


    context "remember token" do
      before :each do
        act_as_guest
        @user = create(:user)
        @user.remember_me
        allow(controller).to receive(:params) { { remember_token: @user.remember_token,
                                                  some_param: 17,
                                                  testparam: "my_value" } }

        @request_path = "http://mercator.informatom.com/some/path"
        allow(controller).to receive_message_chain(:request, :path) { @request_path }
      end

      it "finds the user and sets it as current user" do
        allow(controller).to receive(:current_user=) { true }
        allow(controller).to receive(:redirect_to) { false } #"kills" redirect

        controller.instance_eval{ auto_log_in }
        expect(assigns(:found_user)).to eql @user
      end

      it "redirects to same path without remember token" do
        allow(controller).to receive(:redirect_to) { true } #"kills" redirect
        expect(controller).to receive_message_chain(:current_user=) { true }
        expect(controller).to receive_message_chain(:current_user=) { true }
        expect(controller).to receive(:redirect_to).with("http://mercator.informatom.com/some/path", {params: { some_param: 17,
                                                                                                                testparam: "my_value"},
                                                                                                      status: 301})

        controller.instance_eval{ auto_log_in }
      end
    end
  end


  describe "set_locale" do
    before :each do
      act_as_user
    end

    it "fills locale in session if nothing set" do
      controller.instance_eval{ set_locale }
      expect(session[:locale]).to eql :en
    end

    it "fills locale in session from user locale" do
      @user.update(locale: :de)
      controller.instance_eval{ set_locale }
      expect(session[:locale]).to eql :de
    end

    it "fills locale in session from session locale" do
      session[:locale] = :de
      controller.instance_eval{ set_locale }
      expect(session[:locale]).to eql :de
    end

    it "fills locale in session from session locale" do
      allow(controller).to receive(:params) { { locale: :de} }
      controller.instance_eval{ set_locale }
      expect(session[:locale]).to eql :de
    end

    it "updates the current_user locale" do
      @user.update(locale: :en)
      allow(controller).to receive(:params) { { locale: :de} }
      controller.instance_eval{ set_locale }
      expect(@user.locale).to eql :de
    end
  end


  describe "remember_uri" do
    it "sets return to in session " do
      allow(controller).to receive_message_chain(:request, :referrer) { "some_referrer" }
      controller.instance_eval{ remember_uri }
      expect(session[:return_to]).to eql "some_referrer"
    end

    it "keeps compared in session" do
      session[:compared] = "untouched"
      controller.instance_eval{ remember_uri }
      expect(session[:compared]).to eql "untouched"
    end

    it "initializes compared in session" do
      controller.instance_eval{ remember_uri }
      expect(session[:compared]).to eql []
    end
  end

  # miniprofiler method is irrelevant and needs no test
end