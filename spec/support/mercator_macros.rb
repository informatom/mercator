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

  def act_as_user
    @user = create(:user, email_address: "another.user@informatom.com")
    allow(controller).to receive(:logged_in?) {true}
    allow(controller).to receive(:current_user) { @user }
  end

  def act_as_sales
    @sales = create(:sales, email_address: "another.sales.consultant@informatom.com")
    allow(controller).to receive(:logged_in?) {true}
    allow(controller).to receive(:current_user) { @sales }
  end

  def act_as_salesmanager
    @salesmanager = create(:salesmanager, email_address: "another.sales.consultant@informatom.com")
    allow(controller).to receive(:logged_in?) {true}
    allow(controller).to receive(:current_user) { @salesmanager }
  end
end