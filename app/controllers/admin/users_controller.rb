class Admin::UsersController < Admin::AdminSiteController

  hobo_model_controller
  auto_actions :all

  autocomplete :email_address

  def index
    self.this = User.paginate(:page => params[:page])
                    .search([params[:search], :surname, :first_name, :email_address])
                    .order_by(parse_sort_param(:surname, :email_address, :last_login_at, :firstname,
                                               :sales, :sales_manager, :administrator, :login_count, :logged_in))
    hobo_index
  end
end