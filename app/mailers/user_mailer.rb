class UserMailer < ActionMailer::Base
  default :from => Constant.find_by_key('service_mail').try(:value) || "no-reply@mercator.informatom.com"

  def forgot_password(user, key)
    @user, @key = user, key
    app_name = Rails.application.class.parent_name
    mail( :subject => "#{app_name} -- Passwort vergessen / forgotten password",
          :to      => user.email_address )
  end

  def activation(user, key)
    @user, @key = user, key
    app_name = Rails.application.class.parent_name
    mail( :subject => "#{app_name} -- E-Mail Verifizierung / email verification",
          :to      => user.email_address )
  end

  def login_link(user, key)
    @user, @key = user, key
    app_name = Rails.application.class.parent_name
    mail( :subject => "#{app_name} -- Login Link",
          :to      => user.email_address )
  end

  def consultant_missing
    app_name = Rails.application.class.parent_name
    mail( :subject => "#{app_name} -- Kein Vertriebsmitarbeiter angemeldet / no sales associate logged in",
          :to      => Constant.find_by_key('service_mail').try(:value) )
  end

  def new_submission(submission)
    @submission = submission
    app_name = Rails.application.class.parent_name
    mail(:to => Constant.find_by_key('service_mail').try(:value) ,
         :subject => "#{app_name} -- Neue Kontaktaufnahme")
  end

  def new_comment(comment)
    @comment = comment
    app_name = Rails.application.class.parent_name
    mail(:to => Constant.find_by_key('service_mail').try(:value) ,
         :subject => "#{app_name} -- Neuer Kommentar")
  end

  def job_failed(jobname)
    @jobname = jobname
    mail(:to => Constant.find_by_key('technical_support_mail').try(:value) ,
         :subject => "[MERCATOR - " + CONFIG[:system_name] + "] Job failed / Job gescheitert: #{jobname}")
  end
end