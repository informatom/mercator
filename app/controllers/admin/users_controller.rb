class Admin::UsersController < Admin::AdminSiteController

  hobo_model_controller
  auto_actions :all
  autocomplete :email_address

  def index
    self.this = @users = User.paginate(:page => params[:page])
                             .search([params[:search], :surname, :first_name, :email_address])
                             .order_by(parse_sort_param(:surname, :email_address, :last_login_at, :firstname,
                                                        :sales, :sales_manager, :administrator, :login_count, :logged_in))
    hobo_index
  end

  def destroy
    hobo_destroy do
      if self.this.errors.any?
        @restricting_instances = User.reflect_on_all_associations
                                     .select { |a| a.options[:dependent] == :restrict_with_error }
                                     .map(&:name).select {|a| @this.send(a).present? }
                                     .map{|a| @this.send(a).*.name}[0]
                                     .to_s

        flash[:error] = self.this.errors.first[1] + ": " + @restricting_instances
        flash[:notice] = nil
      end
    end
  end
end