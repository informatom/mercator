class OrdersController < OpensteamController

  def payment
    begin
      @mesonic_order_initializer = Mesonic::OrderInitializer.new( @order, @cart, current_customer )
      @mesonic_order_initializer.initialize_mesonic_order!
      @mesonic_order_initializer.initialize_mesonic_order_items!

      @order.order_number = @mesonic_order_initializer.mesonic_order.c022
      @order.save

      cart_xml = @cart.to_mpay24_xml(order_id: @order.order_number,customer: @order.user)
      mpay24_response = Mpay24Gateway.new( IvellioVellin.mpay24_merchant_id, @order.order_number, cart_xml ).get_response
      @wmbi_url = mpay24_response['LOCATION'].try(:first)
#     @wmbi_url = "https://test.mPAY24.com/app/bin/checkout/payment/f5c4fac03f524881a0b5fc1f8ff03063\n"

      render :action => :payment

    rescue Exception => e
      puts "MPAY24 EXCEPTION : #{e}"
      render :action => :payment_error
    end
  end
end