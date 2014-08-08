class OrderMailer < ActionMailer::Base
  default :from => Constant.find_by_key('service_mail').try(:value) || "no-reply@mercator.informatom.com"

  def confirmation(order: nil)
    @order = order
    @service_mail = Constant.find_by_key('service_mail').value

    mail(:to => order.user.email_address, :bcc => Constant.find_by_key('service_mail').value,
         :subject => "Ivellio-Vellin: Bestellinfo")
  end
end