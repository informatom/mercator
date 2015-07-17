class Contractitem < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    position        :integer, :required, :default => 0
    product_number  :string
    description_de  :string, :required
    description_en  :string
    amount          :integer, :required, :default => 0
    unit            :string
    volume          :integer, :required, :default => 0
    product_price   :decimal, :required, :precision => 13, :scale => 5, :default => 0
    vat             :decimal, :required, :precision => 10, :scale => 2, :default => 0
    value           :decimal, :required, :precision => 13, :scale => 5, :default => 0
    discount_abs    :decimal, :required, :scale => 2, :precision => 10, :default => 0
    term            :integer, :required, :default => 0
    startdate       :date, :required
    volume_bw       :integer, :default => 0
    volume_color    :integer, :default => 0
    marge           :decimal, :required, :precision => 13, :scale => 5, :default => 0
    monitoring_rate :decimal, :required, :precision => 13, :scale => 5, :default => 0
    timestamps
  end


  attr_accessible :position, :product_number, :description_de, :description_en, :amount, :unit, :volume,
                  :product_price, :vat, :value, :discount_abs, :user, :user_id, :contract_id, :contract,
                  :product, :product_id, :toner, :toner_id, :term, :startdate, :volume_bw, :volume_color,
                  :marge, :monitoring_rate, :created_at, :updated_at

  translates :description
  has_paper_trail
  default_scope { order('contractitems.position ASC') }

  validates :position, numericality: { only_integer: true }
  validates :amount, numericality: true
  validates :product_price, numericality: { allow_nil: true }
  validates :vat, numericality: true
  validates :value, numericality: { allow_nil: true }

  belongs_to :user
  belongs_to :contract
  validates :contract, :presence => true
  acts_as_list :scope => :contract

  belongs_to :product
  belongs_to :toner

  has_many :consumableitems

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
    user_is?(acting_user) ||
    acting_user.sales? ||
    acting_user.administrator?
  end

  # --- Instance Methods --- #

  def price
    consumableitems.*.value.reduce(:+) || 0
  end

  def enddate
    startdate + term.months - 1.days
  end

  def monthly_rate
    if term > 0
      price / term
    else
      price
    end
  end

  def value
    monthly_rate + monitoring_rate - discount_abs
  end

  def value_incl_vat
    value * (100 + vat / 100)
  end

  def new_rate(n)
    if [2, 3, 4, 5].include? n
      consumableitems.map{|consumableitem| consumableitem.new_rate(n)}.reduce(:+) || 0
    elsif n==6
      if balance(6) < 0
        (balance(6) / new_rate(1)).floor * -1
      else
        0
      end
    end
  end

  def new_rate_with_monitoring(n)
    if [2, 3, 4, 5].include? n
      new_rate(n) + monitoring_rate
    elsif n == 6
      consumableitems.map{|consumableitem| consumableitem.new_rate(n)}.reduce(:+) || 0
    end
  end

  def balance(n)
    if [1, 2, 3, 4, 5, 6].include? n
      consumableitems.map{|consumableitem| consumableitem.balance(n)}.reduce(:+) || 0
    end
  end

  def months_without_rates(n)
    if [1, 2, 3, 4, 5].include? n
      if balance(n) < 0
        (balance(n) / new_rate(n+1)).floor * -1
      else
        0
      end
    end
  end

  def next_month(n)
    if [1, 2, 3, 4, 5].include? n
      (months_without_rates(n) * new_rate(n+1) + balance(n)) * -1
    end
  end
end