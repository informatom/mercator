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
    startdate       :date, :required
    monitoring_rate  :decimal, :required, :precision => 13, :scale => 5, :default => 0
    volume_bw       :integer, :default => 0
    volume_color    :integer, :default => 0
    marge           :decimal, :required, :precision => 13, :scale => 5, :default => 0
    timestamps
  end


  attr_accessible :position, :product_number, :product_title, :amount, :volume, :vat, :contract_id,
                  :contract, :product, :product_id, :startdate, :volume_bw, :volume_color,
                  :marge, :monitoring_rate, :created_at, :updated_at

  translates :description
  has_paper_trail
  default_scope { order('contractitems.position ASC') }

  validates :position, numericality: { only_integer: true }
  validates :amount, numericality: true
  validates :vat, numericality: true

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

  def price(year)
    consumableitems.*.value(year).sum || 0
  end


  def value(year)
    monthly_rate(year) * amount
  end


  def value_incl_vat(year)
    value(year) * (100 + vat / 100)
  end


  def monthly_rate(year)
    consumableitems.*.monthly_rate(year).sum || 0
  end


  def balance(year)
    consumableitems.*.balance(year).sum || 0
  end


  def months_without_rates(year)
    if balance(year) < 0
      if monthly_rate(year + 1) == 0
        12
      else
        (balance(year) / monthly_rate(year + 1)).ceil * -1
      end
    else
      0
    end
  end


  def next_month(year)
    if balance(year) < 0
      ((months_without_rates(year) + 1) * monthly_rate(year + 1) + balance(year))
    else
      monthly_rate(year + 1)
    end
  end


  def actual_rate(year: nil, month: nil)
    if year == 1
      monthly_rate(1) + monitoring_rate
    else
      if month == months_without_rates(year - 1) + 1
        next_month(year-1) + monitoring_rate
      elsif month < months_without_rates(year - 1) + 1
        monitoring_rate
      else
        monthly_rate(year) + monitoring_rate
      end
    end
  end


  def actual_rate_array
    rate_array = Array.new()
    (1..12).each do |month|
      rate_array[month] = { title: I18n.t("date.month_names", locale: :de)[(month + contract.startdate.month - 1)%12],
                            year1: number_to_currency(actual_rate(year: 1, month: month)),
                            year2: number_to_currency(actual_rate(year: 2, month: month)),
                            year3: number_to_currency(actual_rate(year: 3, month: month)),
                            year4: number_to_currency(actual_rate(year: 4, month: month)),
                            year5: number_to_currency(actual_rate(year: 5, month: month)) }
    end

    return rate_array
  end


  def expenses(year)
    consumableitems.*.expenses(year).sum
  end


  def profit(year)
    (1..12).to_a.map!{|month| self.actual_rate(year: year, month: month)}.sum - expenses(year)
  end
end