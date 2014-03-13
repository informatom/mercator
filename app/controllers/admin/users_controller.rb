class Admin::UsersController < Admin::AdminSiteController

  hobo_model_controller

  auto_actions :all

  autocomplete :name

  def index
    self.this = User.paginate(:page => params[:page])
                    .search([params[:search], :name, :email_address])
                    .order_by(parse_sort_param(:name, :email_address))
    hobo_index
  end
end