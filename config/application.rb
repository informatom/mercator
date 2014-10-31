require File.expand_path('../boot', __FILE__)

require 'rails/all'

# HAS: 20131203 Getting all config variables from application.yml
CONFIG = YAML.load(File.read(File.expand_path('../application.yml', __FILE__)))
CONFIG.merge! CONFIG.fetch(Rails.env, {})
CONFIG.symbolize_keys!


Bundler.require(:default, Rails.env)

module Mercator
  class Application < Rails::Application
    # Hobo: the contentmanager subsite loads contentmanager.css & contentmanager.js
    config.assets.precompile += %w(contentmanager.css contentmanager.js)
    # Hobo: the sales subsite loads sales.css & sales.js
    config.assets.precompile += %w(sales.css sales.js)
    # HAS 20131222 deprecation warning in rails 4
    I18n.enforce_available_locales = true
    I18n.available_locales = [:en, :de]

    # Hobo: the contracting subsite loads contracting.css & contracting.js
    config.assets.precompile += %w(contracting.css contracting.js contracting2.css contentmanager.js contentmanager_index.js)
    # Hobo: the admin subsite loads admin.css & admin.js
    config.assets.precompile += %w(admin.css admin.js contracting2.js)
    # Codemirror
    config.assets.precompile += ["codemirror*", "codemirror/**/*"]

    config.generators do |g|
      g.test_framework :rspec, :fixtures => true
      g.fallbacks[:rspec] = :test_unit
      g.fixture_replacement = :factory_girl_rails
    end

    # Hobo: Named routes have changed in Hobo 2.0.   Set to false to emit both the 2.0 and 1.3 names.
    config.hobo.dont_emit_deprecated_routes = true
    # Hobo: the front subsite loads front.css & front.js
    config.assets.precompile += %w(front.css front.js)

    config.i18n.load_path += Dir[Rails.root.join('locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :de
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.active_support.escape_html_entities_in_json = true
    config.active_record.whitelist_attributes = true
    config.assets.version = '1.0'

    config.generators do |generator|
      generator.test_framework :rspec,
      fixtures: true,
      view_specs: false,
      helper_specs: false,
      routing_specs: false,
      controller_specs: true,
      request_specs: false
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
  end
end
