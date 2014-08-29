class Offer < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    billing_company     :string
    billing_gender      :string
    billing_title       :string
    billing_first_name  :string
    billing_surname     :string
    billing_detail      :string
    billing_street      :string
    billing_postalcode  :string
    billing_city        :string
    billing_country     :string
    shipping_company     :string
    shipping_gender      :string
    shipping_title       :string
    shipping_first_name  :string
    shipping_surname     :string
    shipping_detail     :string
    shipping_street     :string
    shipping_postalcode :string
    shipping_city       :string
    shipping_country    :string
    valid_until         :date, :required
    complete            :boolean
    discount_rel        :decimal, :required, :scale => 2, :precision => 10, :default => 0
    timestamps
  end
  attr_accessible :valid_until, :billing_company,
                  :billing_gender, :billing_title, :billing_first_name, :billing_sur,
                  :billing_detail, :billing_street, :billing_postalcode, :billing_city, :billing_country,
                  :shipping_gender, :shipping_title, :shipping_first_name, :shipping_surname,
                  :shipping_detail, :shipping_street, :shipping_postalcode, :shipping_city, :shipping_country,
                  :offeritems, :user, :user_id, :user, :user_id,
                  :consultant, :consultant_id, :conversation_id, :complete, :discount_rel
  has_paper_trail

  belongs_to :user
  validates :user, :presence => true

  belongs_to :consultant, :class_name => 'User'
  validates :consultant, :presence => true

  belongs_to :conversation

  has_many :offeritems, dependent: :destroy, accessible: true

  lifecycle do
    state :in_progress, :default => true
    state :pending_approval, :valid, :invalid, :accepted

    create :build, :available_to => "User.sales", become: :in_progress,
                   params: [:valid_until, :conversation_id,
                            :billing_company, :billing_gender, :billing_title, :billing_first_name, :billing_surname,
                            :billing_detail, :billing_street, :billing_postalcode, :billing_city, :billing_country,
                            :complete,
                            :user_id, :consultant_id,
                            :shipping_company, :shipping_gender, :shipping_title, :shipping_first_name, :shipping_surname,
                            :shipping_detail, :shipping_street, :shipping_postalcode, :shipping_city, :shipping_country],
                   subsite: "sales"

    transition :add_position, {:in_progress => :in_progress}, available_to: "User.sales", subsite: "sales" do
      last_position = self.offeritems.*.position.max || 0
      Offeritem::Lifecycle.add(acting_user,
                               position: last_position + 10 ,
                               vat: 20,
                               offer_id: self.id,
                               user_id: self.user_id,
                               description_de: "dummy",
                               amount: 1,
                               product_price: 0,
                               value: 0,
                               unit: "Stk.",
                               product_number: "manuell" )
    end

    transition :submit, {:in_progress => :pending_approval}, available_to: "User.sales",
                        if: "Date.today <= valid_until", subsite: "sales" do
      PrivatePub.publish_to("/offers/"+ id.to_s, type: "all")
    end

    transition :place, {:in_progress => :valid}, available_to: "User.sales",
                       if: "Date.today <= valid_until", subsite: "sales" do
      PrivatePub.publish_to("/offers/"+ id.to_s, type: "all")
    end

    transition :place, {:pending_approval => :valid}, available_to: "User.sales_manager",
                       if: "Date.today <= valid_until", subsite: "sales" do
      PrivatePub.publish_to("/offers/"+ id.to_s, type: "all")
    end

    transition :copy, {:valid => :valid}, available_to: :user, if: "Date.today <= valid_until"

    transition :devalidate, {:valid => :invalid}, available_to: :all,
                            if: "Date.today > valid_until", subsite: "sales" do
      PrivatePub.publish_to("/offers/"+ id.to_s, type: "all")
    end

    transition :revise, {:invalid => :in_progress}, available_to: "User.sales", subsite: "sales" do
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
    I18n.t('activerecord.models.offer.one') + " (" +
    I18n.t('activerecord.attributes.offer.lifecycle.states.' + state) + ") " + shipping_name + " " +
    I18n.t('mercator.from') + " " + I18n.l(created_at).to_s
  end

  def sum
    self.offeritems.sum('value') - self.discount
  end

  def discount
    self.discount_rel = 0 unless self.discount_rel
    offeritems.any? ? self.discount_rel * self.offeritems.sum('value') / 100 : 0
  end

  def sum_incl_vat
    if offeritems.any?
      self.sum + self.offeritems.*.calculate_vat_value(discount_rel: self.discount_rel).sum
    else
      0
    end
  end

  def vat_items
    vat_items = Hash.new
    grouped_offeritems = self.offeritems.group_by{|offeritem| offeritem.vat}
    grouped_offeritems.each_pair do |percentage, itemgroup|
      vat_items[percentage] = itemgroup.reduce(0) do |sum, offeritem|
        sum + offeritem.calculate_vat_value(discount_rel: self.discount_rel)
      end
    end
    return vat_items
  end
end