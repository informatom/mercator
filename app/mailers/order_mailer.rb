class OrderMailer < ActionMailer::Base
  default :from => Constant.find_by_key('service_mail').try(:value) || "no-reply@mercator.informatom.com"

  def confirmation(order: nil)
    @order = order

    mail(:to => order.user.email_address,
         :bcc => Constant.find_by_key('service_mail').value,
         :subject => Constant.find_by_key('order_confirmation_mail_subject').value,
         :from => Constant.find_by_key('service_mail').try(:value) )
  end

  def notify_in_payment(orders)
    @orders = orders

    mail(:to => Constant.find_by_key('service_mail').value,
         :subject => Constant.find_by_key('order_notify_in_payment_mail_subject').value,
         :from => Constant.find_by_key('service_mail').try(:value) )
  end
end