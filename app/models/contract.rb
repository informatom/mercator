class Contract < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  hobo_model # Don't put anything above this

  fields do
    contractnumber   :string
    startdate        :date
    customer_account :text
    customer         :text
    timestamps
  end
  attr_accessible :runtime, :startdate, :user_id, :user_id, :created_at, :updated_at,
                  :customer, :customer_account, :contractnumber
  has_paper_trail

  has_many :contractitems, dependent: :destroy, accessible: true

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
#    user_is?(acting_user) ||
    acting_user.sales? ||
    acting_user.administrator?
  end


  # --- Instance Methods --- #

  def enddate
    startdate + 60.months - 1.day
  end


  def balance(n)
    contractitems.*.balance(n).sum
  end


  def actual_rate(year: year, month: month)
    contractitems.*.actual_rate(year: year, month: month).sum
  end


  def actual_rate_array
    rate_array = Array.new()

    (1..12).each do |month|
      rate_array[month] = { title: I18n.t("date.month_names", locale: :de)[(month + startdate.month - 1)%12],
                            year1: number_to_currency(actual_rate(year: 1, month: month)),
                            year2: number_to_currency(actual_rate(year: 2, month: month)),
                            year3: number_to_currency(actual_rate(year: 3, month: month)),
                            year4: number_to_currency(actual_rate(year: 4, month: month)),
                            year5: number_to_currency(actual_rate(year: 5, month: month)) }
    end

    return rate_array
  end


  def expenses(year)
    contractitems.*.expenses(year).sum
  end


  def profit(year)
    contractitems.*.profit(year).sum
  end
end