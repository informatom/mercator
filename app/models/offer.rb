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
    valid_until         :date, :required
    complete            :boolean
    timestamps
  end
  attr_accessible :valid_until, :billing_name, :billing_detail, :billing_street, :billing_postalcode,
                  :billing_city, :billing_country, :shipping_name, :shipping_detail,
                  :shipping_street, :shipping_postalcode, :shipping_city, :shipping_country,
                  :offeritems, :user, :user_id, :user, :user_id,
                  :consultant, :consultant_id, :conversation_id, :complete
  has_paper_trail

  belongs_to :user
  belongs_to :consultant, :class_name => 'User'
  belongs_to :conversation
  validates :consultant, :presence => true

  has_many :offeritems, dependent: :destroy, accessible: true

  validates :user, :presence => true

  lifecycle do
    state :in_progress, :default => true
    state :pending_approval, :valid, :invalid, :accepted

    create :build, :available_to => "User.sales", become: :in_progress,
                   params: [:valid_until, :conversation_id, :user_id, :consultant_id, :billing_name, :billing_detail,
                            :billing_street, :billing_postalcode, :billing_city, :billing_country, :shipping_name,
                            :shipping_detail, :shipping_street, :shipping_postalcode, :shipping_city, :shipping_country, :complete],
                   subsite: "sales"

    transition :add_position, {:in_progress => :in_progress}, available_to: "User.sales", subsite: "sales" do
      last_position = self.offeritems.*.position.max || 0
      Offeritem::Lifecycle.add(acting_user, position: last_position + 10 , vat: 20, offer_id: self.id, user_id: self.user_id,
                               description_de: "dummy", amount: 1, product_price: 0, value: 0, unit: "Stk." )
    end

    transition :submit, {:in_progress => :pending_approval}, available_to: "User.sales", if: "Date.today <= valid_until", subsite: "sales" do
      PrivatePub.publish_to("/offers/"+ id.to_s, type: "all")
    end

    transition :place, {:in_progress => :valid}, available_to: "User.sales", if: "Date.today <= valid_until", subsite: "sales" do
      PrivatePub.publish_to("/offers/"+ id.to_s, type: "all")
    end

    transition :place, {:pending_approval => :valid}, available_to: "User.sales_manager", if: "Date.today <= valid_until", subsite: "sales" do
      PrivatePub.publish_to("/offers/"+ id.to_s, type: "all")
    end

    transition :place, {:invalid => :valid}, available_to: "User.sales", if: "Date.today <= valid_until", subsite: "sales" do
      PrivatePub.publish_to("/offers/"+ id.to_s, type: "all")
    end

    transition :copy, {:valid => :valid}, available_to: :user, if: "Date.today <= valid_until"

    transition :devalidate, {:valid => :invalid}, available_to: :all, if: "Date.today > valid_until", subsite: "sales" do
      PrivatePub.publish_to("/offers/"+ id.to_s, type: "all")
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

  def sum
    self.offeritems.sum('value')
  end

  def sum_incl_vat
    self.sum + self.offeritems.*.vat_value.sum
  end

  def vat_items
    vat_items = Hash.new
    grouped_offeritems = self.offeritems.group_by{|offeritems| offeritems.vat}
    grouped_offeritems.each_pair do |percentage, itemgroup|
      vat_items[percentage] = itemgroup.reduce(0) {|sum, offeritems| sum + offeritems.vat_value}
    end
    return vat_items
  end

end