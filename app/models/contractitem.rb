class Contractitem < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  hobo_model # Don't put anything above this

  fields do
    position        :integer, :required, :default => 0
    product_number  :string
    product_title   :string
    amount          :integer, :required, :default => 0
    volume          :integer, :required, :default => 0
    vat             :decimal, :required, :precision => 10, :scale => 2, :default => 0
    term            :integer, :required, :default => 0
    startdate       :date, :required
    volume_bw       :integer, :default => 0
    volume_color    :integer, :default => 0
    marge           :decimal, :required, :precision => 13, :scale => 5, :default => 0
    timestamps
  end


  attr_accessible :position, :product_number, :product_title, :amount, :volume,
                  :vat, :user, :user_id, :contract_id, :contract, :product, :product_id,
                  :term, :startdate, :volume_bw, :volume_color,
                  :marge, :monitoring_rate, :created_at, :updated_at

  translates :description
  has_paper_trail
  default_scope { order('contractitems.position ASC') }

  validates :position, numericality: { only_integer: true }
  validates :amount, numericality: true
  validates :vat, numericality: true

  belongs_to :user
  belongs_to :contract
  validates :contract, :presence => true
  acts_as_list :scope => :contract

  belongs_to :product

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
    consumableitems.*.value.sum || 0
  end


  def enddate
    startdate + term.months - 1.days
  end


  def monthly_rate
    if term && term > 0
      price.to_f / term
    else
      price.to_f
    end
  end


  def value
    monthly_rate * amount
  end


  def value_incl_vat
    value * (100 + vat / 100)
  end


  def new_rate(n)
    if [2, 3, 4, 5].include? n
      consumableitems.*.new_rate(n).sum || 0
    end
  end


  def balance(n)
    if [1, 2, 3, 4, 5].include? n
      consumableitems.*.balance(n).sum || 0
    end
  end


  def months_without_rates(n)
    if [1, 2, 3, 4].include? n
      if balance(n) < 0
        (balance(n).to_f / new_rate(n+1)).ceil * -1
      else
        0
      end
    end
  end


  def next_month(n)
    if [1, 2, 3, 4].include? n
      if balance(n) < 0
        (months_without_rates(n) * new_rate(n+1) + balance(n)) * -1
      else
        new_rate(n+1)
      end
    end
  end


  def actual_rate(year: year, month: month)
    if year == 1
      monthly_rate
    else
      if month == months_without_rates(year-1) + 1
        next_month(year-1)
      elsif month < months_without_rates(year-1) + 1
        0
      else
        new_rate(year)
      end
    end
  end


  def actual_rate_array
    rate_array = Array.new()

    (1..12).each do |month|
      rate_array[month] = { title: I18n.t("date.month_names", locale: :de)[month],
                            year1: number_to_currency(actual_rate(year: 1, month: month)),
                            year2: number_to_currency(actual_rate(year: 2, month: month)),
                            year3: number_to_currency(actual_rate(year: 3, month: month)),
                            year4: number_to_currency(actual_rate(year: 4, month: month)),
                            year5: number_to_currency(actual_rate(year: 5, month: month)) }
    end

    return rate_array
  end
end