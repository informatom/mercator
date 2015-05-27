class Admin::OrdersController < Admin::AdminSiteController

  hobo_model_controller
  auto_actions :all

  def destroy
    hobo_destroy do
      redirect_to admin_orders_path  # better but still problematic
    end
  end

  def index
    # Reverse Lookup for state
    key = I18n.t("activerecord.attributes.order.lifecycle.states").key(params[:search])
    params[:search] = key.to_s if key

    self.this = @orders = Order.paginate(:page => params[:page])
                               .search([params[:search], :state])
                               .order_by(parse_sort_param(:state, :updated_at))
    hobo_index
  end
end