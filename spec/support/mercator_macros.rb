module MercatorMacros

  def no_redirects
    allow(controller).to receive(:domain_cms_redirect) {true}
    allow(controller).to receive(:domain_shop_redirect) {true}
  end


  def act_as_admin
    @admin = create(:admin)
    allow(controller).to receive(:logged_in?) {true}
    allow(controller).to receive(:current_user) { @admin }
  end
end