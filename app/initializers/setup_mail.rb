ActionMailer::Base.smtp_settings = {
  :address => "localhost",
  :port => 25,
  :domain => "mittenin.at",
  :enable_starttlls_auto => false
}

ActionMailer::Base.default_url_options[:host] = "mercator.mittenin.at"