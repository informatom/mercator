require 'spec_helper'

describe Contracting::ConsumableitemsController, :type => :controller do
  context "crud actions" do
    before :each do
      no_redirects and act_as_sales
      @user = create(:user)
      @contract = create(:contract, consultant_id: @sales.id,
                                    customer_id: @user.id)
      @contractitem = create(:contractitem, contract_id: @contract.id,
                                            user_id: @user.id)
      @instance = create(:consumableitem, contractitem_id: @contractitem.id)
    end
  end
end