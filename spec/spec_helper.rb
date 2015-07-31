require 'simplecov'
SimpleCov.start 'rails'

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require "email_spec"

#HAS:20140109 needed for fixture_file_upload()
include ActionDispatch::TestProcess

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|

  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"

  config.include FactoryGirl::Syntax::Methods
  config.include JsonSpec::Helpers

  config.include MercatorMacros
  config.include MercatorSharedContexts

  config.include(EmailSpec::Helpers)
  config.include(EmailSpec::Matchers)

  config.example_status_persistence_file_path = Rails.root.join("spec/support/rspec_example_status")
end