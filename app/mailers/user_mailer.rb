class UserMailer < ActionMailer::Base
  default :from => "no-reply@mercator.informatom.com"

  def forgot_password(user, key)
    @user, @key = user, key
    mail( :subject => "#{app_name} -- forgotten password",
          :to      => user.email_address )
  end

  def activation(user, key)
    @user, @key = user, key
    mail( :subject => "#{app_name} -- activate",
          :to      => user.email_address )
  end

end