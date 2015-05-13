require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

#HAS:20140109 needed for fixture_file_upload()
include ActionDispatch::TestProcess

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  # HAS 20131113: For Database Cleaner
  # config.use_transactional_fixtures = true
  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"

  config.include FactoryGirl::Syntax::Methods
end