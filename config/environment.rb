# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Mercator::Application.initialize!

ActionMailer::Base.smtp_settings = {
  :enable_starttlls_auto => false,
  :domain => "mercator.mittenin.at"
}

ActionMailer::Base.default_url_options[:host] = "mercator.mittenin.at"