require File.expand_path('../boot', __FILE__)

require 'rails/all'

# HAS: 20131203 Getting all config variables from application.yml
CONFIG = YAML.load(File.read(File.expand_path('../application.yml', __FILE__)))
CONFIG.merge! CONFIG.fetch(Rails.env, {})
CONFIG.symbolize_keys!


Bundler.require(:default, Rails.env)

module Mercator
  class Application < Rails::Application
    config.middleware.use I18n::JS::Middleware # Needed for I18n.js
    config.assets.initialize_on_precompile = true # Needed for I18n.js
    config.assets.precompile << /\.(?:svg|eot|woff|ttf|png|jpg|gif|jpeg|json)\z/

    I18n.enforce_available_locales = true
    I18n.available_locales = [:en, :de]

    config.generators do |g|
      g.test_framework :rspec, :fixtures => true
      g.fallbacks[:rspec] = :test_unit
      g.fixture_replacement = :factory_girl_rails
    end

    config.hobo.dont_emit_deprecated_routes = true

    config.i18n.load_path += Dir[Rails.root.join('locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :de
    config.encoding = "utf-8"

    config.filter_parameters += [:password]
    config.active_support.escape_html_entities_in_json = true
    config.active_record.whitelist_attributes = true
    config.assets.version = '1.0'

    config.generators do |generator|
      generator.test_framework :rspec, fixtures: true, view_specs: false, helper_specs: false,
      routing_specs: false, controller_specs: true, request_specs: false
      generator.fixture_replacement :factory_girl, dir: "spec/factories"
    end

    config.autoload_paths += %W(#{config.root}/app/models/ckeditor)

    config.time_zone = 'Vienna'
    config.active_record.default_timezone = :local

#   config.hobo.show_translation_keys = true

    config.ember.app_name = "Contracting"
    config.handlebars.templates_root = "contracting/templates"
    config.handlebars.precompile = true

    WillPaginate.per_page = 20

    Ahoy.track_visits_immediately = true   # User tracking
    Ahoy.geocode = false  # sync Geacoding is way too slow

# Customer specific assets
    config.assets.paths << Rails.root.join("vendor", "customer", "assets", "images").to_s
    config.assets.paths << Rails.root.join("vendor", "customer", "assets", "javascripts").to_s
    config.assets.paths << Rails.root.join("vendor", "customer", "assets", "stylesheets").to_s
    config.assets.paths << Rails.root.join("vendor", "customer", "assets", "fonts").to_s
  end
end