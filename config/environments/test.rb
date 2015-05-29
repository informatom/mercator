Mercator::Application.configure do
  config.cache_classes = true
  config.eager_load = false

  # Configure static asset server for tests with Cache-Control for performance
  config.serve_static_assets = true
  config.static_cache_control = "public, max-age=3600"

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates
  config.action_dispatch.show_exceptions = false

  config.action_controller.allow_forgery_protection    = false
  config.action_mailer.delivery_method = :test

  config.action_mailer.raise_delivery_errors = false

  config.active_record.mass_assignment_sanitizer = :strict
  config.active_support.deprecation = :stderr

  config.i18n.default_locale = :en
end