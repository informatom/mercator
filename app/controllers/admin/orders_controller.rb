class Admin::OrdersController < Admin::AdminSiteController

  hobo_model_controller
  auto_actions :all

  def destroy
    hobo_destroy do
      redirect_to admin_orders_path  # better but still problematic
    end
  end

  def index
    @orders = Order.all

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
              billing_method:      (I18n.t("activerecord.attributes.order.lifecycle.transitions.#{order.billing_method}") if order.billing_method),
              billing_company:     order.billing_company,
              shipping_method:     (I18n.t("activerecord.attributes.order.lifecycle.transitions.#{order.shipping_method}") if order.shipping_method),
              shipping_company:    order.shipping_company,
              erp_customer_number: order.erp_customer_number,
              erp_billing_number:  order.erp_billing_number,
              erp_order_number:    order.erp_order_number,
              lineitems:           order.lineitems.count,
              sum_incl_vat:        order.sum_incl_vat,
              created_at:          order.created_at.utc.to_i*1000,
              updated_at:          order.updated_at.utc.to_i*1000
            }
          }
        }
      }
    end
  end
end