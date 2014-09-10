# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
run Mercator::Application

DelayedJobWeb.use Rack::Auth::Basic do |username, password|
  username == 'mercator' && password == 'mercator2014'
end
