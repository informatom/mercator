require 'spec_helper'

describe Admin::ValuesController , :type => :controller do

  describe "crud actions" do
    before :each do
      no_redirects and act_as_admin

      @instance = create(:value, state: "textual",
                                 amount: nil,
                                 flag: nil)
      @invalid_attributes = attributes_for(:value, amount: nil).except(:state)
    end

    it_behaves_like("crud actions")
  end
end