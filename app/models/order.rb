class Order < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    billing_method      :string
    billing_name        :string
    billing_detail      :string
    billing_street      :string
    billing_postalcode  :string
    billing_city        :string
    billing_country     :string
    shipping_method     :string
    shipping_name       :string
    shipping_detail     :string
    shipping_street     :string
    shipping_postalcode :string
    shipping_city       :string
    shipping_country    :string
    timestamps
  end

  attr_accessible :billing_method, :billing_name, :billing_detail, :billing_street, :billing_postalcode,
                  :billing_city, :billing_country, :shipping_method, :shipping_name, :shipping_detail,
                  :shipping_street, :shipping_postalcode, :shipping_city, :shipping_country,
                  :lineitems, :user, :user_id
  has_paper_trail

  belongs_to :user, :creator => true
  view_hints.parent :user

  belongs_to :conversation

  has_many :lineitems, dependent: :destroy
  children :lineitems

#  validates :user, :presence => true

  lifecycle do
    state :basket, :default => true
    state :ordered, :paid, :shipped, :offer

    transition :create_key, {:basket => :basket}, :available_to => :all, :new_key => true

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
    acting_user.administrator?
  end

  def view_permitted?(field)
    acting_user.administrator? || acting_user.sales? || (user_is? acting_user)
  end

  # --- Instance Methods --- #

  def name
    "Bestellung vom " + I18n.l(created_at).to_s
  end

  def add_product(product: nil, amount: 1)
    if lineitem = self.lineitems.where(product_number: product.number).first
      lineitem.increase_amount(amount: amount)
    else
      Lineitem.create_from_product(order_id: self.id, product: product, amount: amount,
                                   position: self.lineitems.count + 1, user_id: self.user_id)
    end
  end

  def merge(basket: nil)
    if basket.id !=id #first run or second run?
      positions_merged = "merged" if lineitems.present? && basket.lineitems.present?
      basket.lineitems.each do |lineitem|
        duplicate = self.lineitems.where(product_number: lineitem.product_number).first
        if duplicate.present?
          duplicate.merge(lineitem: lineitem)
        else
          lineitem.update_attributes(order_id: id)
        end
      end

      basket.delete
      return positions_merged
    end
  end
end