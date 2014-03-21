class IvellioVellin::Cart < ActiveRecord::Base
  def to_mpay24_xml( order_id, delivery = true, customer = nil )
    indent = 2
    if delivery
      price = "%0.2f" % self.cart_items.with_shipping_rate_for( customer ).total_price
    else
      price = "%0.2f" % self.cart_items.reload.total_price
    end

    xml = Builder::XmlMarkup.new(:indent => indent)
    xml.Order do
      xml.Tid order_id
      xml.Price price
    end
  end
end