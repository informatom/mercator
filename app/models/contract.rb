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


  def to_csv
    CSV.generate do |csv|
      csv << [ "id", "Kunde", "Account", "Vertragsnummer", "Startdatum", "Enddatum",
               "Gutschrift/Nachzahlung 1", "Gutschrift/Nachzahlung 2", "Gutschrift/Nachzahlung 3",
               "Gutschrift/Nachzahlung 4", "Gutschrift/Nachzahlung 5",
               "Ausgaben 1", "Ausgaben 2", "Ausgaben 3", "Ausgaben 4", "Ausgaben 5",
               "Deckungsbeitrag 1", "Deckungsbeitrag 2", "Deckungsbeitrag 3", "Deckungsbeitrag 4", "Deckungsbeitrag 5",
               "erzeugt", "geändert" ]
      csv << [ id, customer, customer_account, contractnumber, startdate, enddate,
               balance(1), balance(2), balance(3), balance(4), balance(5),
               expenses(1), expenses(2), expenses(3), expenses(4), expenses(5),
               profit(1), profit(2), profit(3), profit(4), profit(5),
               created_at, updated_at ]
      csv << []

      contractitems.each do |contractitem|
        csv << [ "Position", "Produktnummer", "Produkt Titel", "Menge", "Anzahl", "Mwst.",
                  "Startdatum", "Monitoring", "Reichweite S/W", "Reichweite Farbe", "Marge",
                  "Monatsrate 1", "Monatsrate 2", "Monatsrate 3", "Monatsrate 4", "Monatsrate 5",
                  "Monate ohne Rate 2", "Monate ohne Rate 3", "Monate ohne Rate 4", "Monate ohne Rate 5",
                  "Rate im Folgemonat 2", "Rate im Folgemonat 3", "Rate im Folgemonat 4", "Rate im Folgemonat 5",
                  "Gutschrift/Nachzahlung 1", "Gutschrift/Nachzahlung 2", "Gutschrift/Nachzahlung 3",
                  "Gutschrift/Nachzahlung 4", "Gutschrift/Nachzahlung 5",
                  "Ausgaben 1", "Ausgaben 2", "Ausgaben 3", "Ausgaben 4", "Ausgaben 5",
                  "Deckungsbeitrag 1", "Deckungsbeitrag 2", "Deckungsbeitrag 3", "Deckungsbeitrag 4", "Deckungsbeitrag 5",
                  "erzeugt", "geändert"]
        csv << [ contractitem.position,
                 contractitem.product_number,
                 contractitem.product_title,
                 contractitem.amount,
                 contractitem.volume,
                 contractitem.vat,
                 contractitem.startdate,
                 contractitem.monitoring_rate,
                 contractitem.volume_bw,
                 contractitem.volume_color,
                 contractitem.marge,
                 contractitem.monthly_rate(1),
                 contractitem.monthly_rate(2),
                 contractitem.monthly_rate(3),
                 contractitem.monthly_rate(4),
                 contractitem.monthly_rate(5),
                 contractitem.months_without_rates(1),
                 contractitem.months_without_rates(2),
                 contractitem.months_without_rates(3),
                 contractitem.months_without_rates(4),
                 contractitem.next_month(1),
                 contractitem.next_month(2),
                 contractitem.next_month(3),
                 contractitem.next_month(4),
                 contractitem.balance(1),
                 contractitem.balance(2),
                 contractitem.balance(3),
                 contractitem.balance(4),
                 contractitem.balance(5),
                 contractitem.expenses(1),
                 contractitem.expenses(2),
                 contractitem.expenses(3),
                 contractitem.expenses(4),
                 contractitem.expenses(5),
                 contractitem.profit(1),
                 contractitem.profit(2),
                 contractitem.profit(3),
                 contractitem.profit(4),
                 contractitem.profit(5),
                 contractitem.created_at,
                 contractitem.updated_at ]

        csv <<  [ "", "Position", "Produktnummer", "Produkttitle", "Vertragsart", "Produktlinie",
                  "Menge", "Reichweite", "Preis 1", "Positionswert 1",
                  "EK Jahr 1", "EK Jahr 2", "EK Jahr 3", "EK Jahr 4", "EK Jahr 5",
                  "Verbrauch 1", "Verbrauch 2", "Verbrauch 3", "Verbrauch 4", "Verbrauch 5",
                  "Monatsrate 1", "Monatsrate 2", "Monatsrate 3", "Monatsrate 4", "Monatsrate 5",
                  "Abrechnung 1", "Abrechnung 2", "Abrechnung 3", "Abrechnung 4", "Abrechnung 5",
                  "erzeugt", "geändert"]
        contractitem.consumableitems.each do |consumableitem|
          csv << [ "",
                   consumableitem.position,
                   consumableitem.product_number,
                   consumableitem.product_title,
                   consumableitem.contract_type,
                   consumableitem.product_line,
                   consumableitem.amount,
                   consumableitem.theyield,
                   consumableitem.price(1),
                   consumableitem.value(1),
                   consumableitem.wholesale_price1,
                   consumableitem.wholesale_price2,
                   consumableitem.wholesale_price3,
                   consumableitem.wholesale_price4,
                   consumableitem.wholesale_price5,
                   consumableitem.consumption1,
                   consumableitem.consumption2,
                   consumableitem.consumption3,
                   consumableitem.consumption4,
                   consumableitem.consumption5,
                   consumableitem.monthly_rate(1),
                   consumableitem.monthly_rate(2),
                   consumableitem.monthly_rate(3),
                   consumableitem.monthly_rate(4),
                   consumableitem.monthly_rate(5),
                   consumableitem.balance(1),
                   consumableitem.balance(2),
                   consumableitem.balance(3),
                   consumableitem.balance(4),
                   consumableitem.balance(5),
                   consumableitem.created_at,
                   consumableitem.updated_at ]
        end
        csv << []
      end
      csv << []
    end
  end
end