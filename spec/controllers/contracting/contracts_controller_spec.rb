require 'spec_helper'

describe Contracting::ContractsController, :type => :controller do
  context "crud actions" do
    before :each do
      no_redirects and act_as_sales
      @user = create(:user)

      @instance = create(:contract, consultant_id: @sales.id,
                                    customer_id: @user.id)
      @attributes = attributes_for(:contract, consultant_id: @sales.id,
                                              customer_id: @user.id)
    end
  end
end