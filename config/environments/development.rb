Mercator::Application.configure do
  # Hobo: tell ActiveReload about dryml
  config.watchable_dirs[File.join(config.root, 'app/views')] = ['dryml']

  config.cache_classes = false

# HAS: 20131219 according to deprecation warning on update to Rails 4
  config.eager_load = false

  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.action_mailer.raise_delivery_errors = false
  config.active_support.deprecation = :log
  config.action_dispatch.best_standards_support = :builtin
  config.active_record.mass_assignment_sanitizer = :strict

  config.assets.compress = false
  config.assets.debug = true
end
