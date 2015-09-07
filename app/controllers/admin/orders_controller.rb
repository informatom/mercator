class Admin::OrdersController < Admin::AdminSiteController

  hobo_model_controller
  auto_actions :all

  skip_before_filter :admin_required
  before_filter :sales_required

  def destroy
    hobo_destroy do
      redirect_to admin_orders_path  # better but still problematic
    end
  end

  def index
    if params[:in_payment] == 'true'
      @orders = Order.where(state: ['in payment', 'payment_failed'])
    else
      @orders = Order.all
    end

    respond_to do |format|
      format.html { respond_with [] }
      format.text {
        render json: {
          status: "success",
          total: @orders.count,
          records: @orders.collect {
            |order| {
              recid:               order.id,
              state:               order.state,
              user:                (order.user.name if order.user),
              billing_method:      (I18n.t("activerecord.attributes.order.lifecycle.transitions.#{order.billing_method}") if order.billing_method),
              billing_company:     order.billing_company,
              shipping_method:     (I18n.t("activerecord.attributes.order.lifecycle.transitions.#{order.shipping_method}") if order.shipping_method),
              shipping_company:    order.shipping_company,
              erp_customer_number: order.erp_customer_number,
              erp_billing_number:  order.erp_billing_number,
              erp_order_number:    order.erp_order_number,
              lineitems:           order.lineitems.count,
              sum_incl_vat:        order.sum_incl_vat,
              created_at_date:     order.created_at.to_date(),
              created_at_time:     order.created_at.to_s(:time),
              updated_at_date:     order.updated_at.to_date(),
              updated_at_time:     order.updated_at.to_s(:time)
            }
          }
        }
      }
    end
  end
end