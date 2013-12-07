# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Mercator::Application.initialize!

ActionMailer::Base.smtp_settings = {
  :domain => CONFIG[:smtp_domain],
  :enable_starttls_auto => false
}