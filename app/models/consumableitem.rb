class Consumableitem < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    position        :integer, :required
    product_number  :string
    contract_type   :string
    product_line    :string
    description_de  :string
    description_en  :string
    amount          :integer, :required, :default => 0
    theyield        :integer, :required, :default => 0
    wholesale_price :decimal, :required, :precision => 13, :scale => 5, :default => 0
    term            :integer, :required, :default => 0
    consumption1    :integer, :required, :default => 0
    consumption2    :integer, :required, :default => 0
    consumption3    :integer, :required, :default => 0
    consumption4    :integer, :required, :default => 0
    consumption5    :integer, :required, :default => 0
    consumption6    :integer, :required, :default => 0
    balance6        :decimal, :required, :precision => 13, :scale => 5, :default => 0
    timestamps
  end

  attr_accessible :position, :product_number, :product_line, :description_de, :description_en, :amount,
                  :theyield, :wholesale_price, :term, :consumption1, :consumption2, :consumption3,
                  :consumption4, :consumption5, :consumption6, :balance6, :created_at, :updated_at,
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

  def price
    wholesale_price * (100 + contractitem.marge) / 100
  end

  def value
    price * amount
  end

  def monthly_rate
    value / term
  end

  def new_rate(n)
    if n == 2
      if contractitem.term && (amount * 12 >=  contractitem.term)
        consumption1 * price / 12
      else
        monthly_rate
      end

    elsif [3, 4, 5, 6].include? n
      eval('consumption' + (n-1).to_s) * price / 12
    end
  end

  def balance(n)
    if n == 1
      (new_rate(n+1) - monthly_rate) * 12
    elsif [2, 3, 4, 5].include? n
      (new_rate(n+1) - new_rate(n)) * 12
    end
  end
end