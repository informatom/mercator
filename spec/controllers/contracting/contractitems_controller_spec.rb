require 'spec_helper'

describe Contracting::ContractitemsController, :type => :controller do
  context "crud actions" do
    before :each do
      no_redirects and act_as_sales
      @user = create(:user)

      @contract = create(:contract, consultant_id: @sales.id,
                                    customer_id: @user.id)
      @instance = create(:contractitem, contract_id: @contract.id,
                                        user_id: @user.id)
    end
  end
end