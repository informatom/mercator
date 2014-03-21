class CustomersController < OpensteamController
  def create
    @customer_initializer = Mesonic::AccountInitializer2.new( params[:ivellio_vellin_customer] )
    @customer_initializer.initialize_account!
    @customer = @customer_initializer.ivellio_customer
  end

  def update
    @customer = IvellioVellin::Customer.find( params[:id] )

    @customer.mesonic_account_id = params[:customer][:mesonic_account_id] if params[:customer][:mesonic_account_id]
    @customer.account_number = params[:customer][:account_number] if params[:customer][:account_number]
    @customer.active = params[:customer][:active] if params[:customer][:active]
    @customer.password = params[:customer][:password] if params[:customer][:password]
    @customer.password_confirmation = params[:customer][:password_confirmation] if params[:customer][:password_confirmation]

    @customer.set_account_number_mesoprim if params[:customer][:account_number]
    @customer.set_mesonic_account_mesoprim if params[:customer][:mesonic_account_id]
  end
end