class Order < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    billing_method      :string, :required
    billing_name        :string, :required
    billing_detail      :string
    billing_street      :string, :required
    billing_postalcode  :string, :required
    billing_city        :string, :required
    billing_country     :string, :required
    shipping_method     :string, :required
    shipping_name       :string, :required
    shipping_detail     :string
    shipping_street     :string, :required
    shipping_postalcode :string, :required
    shipping_city       :string, :required
    shipping_country    :string, :required
    timestamps
  end

  attr_accessible :billing_method, :billing_name, :billing_detail, :billing_street, :billing_postalcode,
                  :billing_city, :billing_country, :shipping_method, :shipping_name, :shipping_detail,
                  :shipping_street, :shipping_postalcode, :shipping_city, :shipping_country,
                  :lineitems, :user, :user_id
  has_paper_trail

  belongs_to :user, :creator => true
  validates :user, :presence => true
  view_hints.parent :user
  
  belongs_to :conversation

  has_many :lineitems, dependent: :destroy
  children :lineitems

#  validates :user, :presence => true

  lifecycle do
    state :basket, :default => true
    state :ordered, :paid, :shipped, :offer
    transition :order, {[:basket, :offer] => :ordered}
    transition :payment, {:ordered => :paid}
    transition :shippment, {:paid => :shipped}, :available_to => "User.administrator"
  end

  # --- Permissions --- #

  def create_permitted?
    true
  end

  def update_permitted?
    acting_user.administrator? || (user_is? acting_user) 
  end

  def destroy_permitted?
    false
  end

  def view_permitted?(field)
    acting_user.administrator? || (user_is? acting_user) 
  end
end