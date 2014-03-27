class Inventory < ActiveRecord::Base
  def price(customer = nil )
    regular_price = self.prices.regular.for_date(Time.now).first.to_s

    return regular_price if customer.nil?
    if !(customer_prices = self.prices.by_customer( customer.account_number ) ).empty?
      customer_prices.first.to_s
    else
      return regular_price
    end
  end

  has_many :prices, :class_name => "Mesonic::Price", :foreign_key => "c000", :primary_key => :Artikelnummer
end