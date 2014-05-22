class UserMailer < ActionMailer::Base
  default :from => "no-reply@mercator.informatom.com"

  def forgot_password(user, key)
    @user, @key = user, key
    mail( :subject => "#{app_name} -- forgotten password",
          :to      => user.email_address )
  end

  def activation(user, key)
    @user, @key = user, key
    mail( :subject => "#{app_name} -- E-Mail Verifizierung / email verification",
          :to      => user.email_address )
  end

  def login_link(user, key)
    @user, @key = user, key
    mail( :subject => "#{app_name} -- Login Link",
          :to      => user.email_address )
  end
end