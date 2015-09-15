class Consumableitem < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    position         :integer, :required
    product_number   :string
    product_title    :string
    contract_type    :string
    product_line     :string
    amount           :integer, :required, :default => 0
    theyield         :integer, :required, :default => 0
    wholesale_price1 :decimal, :required, :precision => 13, :scale => 5, :default => 0
    wholesale_price2 :decimal, :required, :precision => 13, :scale => 5, :default => 0
    wholesale_price3 :decimal, :required, :precision => 13, :scale => 5, :default => 0
    wholesale_price4 :decimal, :required, :precision => 13, :scale => 5, :default => 0
    wholesale_price5 :decimal, :required, :precision => 13, :scale => 5, :default => 0
    consumption1     :integer, :required, :default => 0
    consumption2     :integer, :required, :default => 0
    consumption3     :integer, :required, :default => 0
    consumption4     :integer, :required, :default => 0
    consumption5     :integer, :required, :default => 0
    consumption6     :integer, :required, :default => 0
    timestamps
  end

  attr_accessible :position, :product_number, :product_line, :product_title, :amount, :theyield,
                  :wholesale_price1, :wholesale_price2, :wholesale_price3, :wholesale_price4,
                  :wholesale_price5, :consumption1, :consumption2, :consumption3,
                  :consumption4, :consumption5, :consumption6, :created_at, :updated_at,
                  :contract_type, :contractitem_id

  belongs_to :contractitem
  has_paper_trail

  validates :contractitem, :presence => true


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
    acting_user.sales? ||
    acting_user.administrator?
  end


  # --- Instance methods --- #

  def price(year)
    (wholesale_price(year) * (100 + contractitem.marge) / 100).ceil
  end


  def value(year)
    price(year) * amount
  end


  def relevant_months(year)
    if contractitem.contract.startdate + (year-1).years - contractitem.startdate > 0
      12
    else
      12 + contractitem.contract.startdate.month - contractitem.startdate.month
    end
  end


  def monthly_rate(year)
    if contractitem.contract.startdate + (year-1).years - contractitem.startdate > 0
      consumption(year - 1).to_f * price(year) / relevant_months(year - 1)
    elsif contractitem.contract.startdate + year.years - contractitem.startdate > 0
      value(year).to_f / relevant_months(year)
    else
      0
    end
  end


  def balance(year)
    if contractitem.contract.startdate + year.years - contractitem.startdate > 0
      (consumption(year).to_f * price(year) / relevant_months(year) - monthly_rate(year)) * relevant_months(year)
    else
      0
    end
  end


  def consumption(year)
    eval('consumption' + year.to_s)
  end


  def wholesale_price(year)
    eval('wholesale_price' + year.to_s)
  end
end