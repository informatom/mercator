class IvellioVellin::Cart < ActiveRecord::Base

  def to_mpay24_xml(order_id: nil, customer: nil)
    indent = 2
    price = "%0.2f" % self.sum_incl_vat

    xml = Builder::XmlMarkup.new(:indent => indent)
    xml.Order do
      xml.Tid order_id
      xml.Price price
    end
  end
end