# Run with: rackup private_pub.ru -s thin -E production
require "bundler/setup"
require "yaml"
require "faye"
require "private_pub"

Faye::WebSocket.load_adapter('thin')

config_path = File.expand_path("../config/private_pub.yml"
PrivatePub.load_config(config_path, __FILE__), ENV["RAILS_ENV"] || "development")
run PrivatePub.faye_app