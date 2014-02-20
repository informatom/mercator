class Offer < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    billing_name        :string
    billing_detail      :string
    billing_street      :string
    billing_postalcode  :string
    billing_city        :string
    billing_country     :string
    shipping_name       :string
    shipping_detail     :string
    shipping_street     :string
    shipping_postalcode :string
    shipping_city       :string
    shipping_country    :string
    timestamps
  end
  attr_accessible :billing_name, :billing_detail, :billing_street, :billing_postalcode,
                  :billing_city, :billing_country, :shipping_name, :shipping_detail,
                  :shipping_street, :shipping_postalcode, :shipping_city, :shipping_country,
                  :offeritems, :user, :user_id, :user, :user_id, :consultant, :consultant_id, :conversation_id
  has_paper_trail

  belongs_to :user
  belongs_to :consultant, :class_name => 'User'
  belongs_to :conversation
  validates :consultant, :presence => true

  has_many :offeritems, dependent: :destroy, accessible: true

  validates :user, :presence => true

  lifecycle do
    state :in_progress, :default => true
    state :valid, :invalid, :accepted

    create :build, :available_to => "User.sales", become: :in_progress,
                   params: [:conversation_id, :user_id, :consultant_id, :billing_name, :billing_detail,
                            :billing_street, :billing_postalcode, :billing_city, :billing_country, :shipping_name,
                            :shipping_detail, :shipping_street, :shipping_postalcode, :shipping_city, :shipping_country],
                   subsite: "sales"

    transition :add_position, {:in_progress => :in_progress}, available_to: "User.sales", subsite: "sales" do
      Offeritem::Lifecycle.add(acting_user, position: 1000, vat: 20, offer_id: self.id, user_id: self.user_id,
                               description_de: "dummy", amount: 1, product_price: 0, value: 0, unit: "Stk." )
    end
  end

  # --- Permissions --- #

  def create_permitted?
    acting_user.sales? ||
    acting_user.administrator?
  end

  def update_permitted?
    acting_user.sales? ||
    acting_user.administrator?
  end

  def destroy_permitted?
    acting_user.sales? ||
    acting_user.administrator?
  end

  def view_permitted?(field)
    acting_user.administrator? ||
    acting_user.sales? ||
    user_is?(acting_user)
  end

  # --- Instance Methods --- #

  def name
    shipping_name + " / " + I18n.l(created_at).to_s
  end

end
