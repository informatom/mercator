Mercator::Application.configure do
  # Hobo: tell ActiveReload about dryml
  config.watchable_dirs[File.join(config.root, 'app/views')] = ['dryml']

  config.cache_classes = false
  config.eager_load = false

  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp
  config.active_support.deprecation = :log
  config.action_dispatch.best_standards_support = :builtin
  config.active_record.mass_assignment_sanitizer = :strict

  config.assets.compress = false
  config.assets.debug = true

# config.hobo.show_translation_keys = true

  ActionMailer::Base.smtp_settings = { :domain => "localhost", :enable_starttls_auto => false }

  config.ember.variant = :development
end