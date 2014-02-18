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
                  :offeritems, :user, :user_id
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

end
