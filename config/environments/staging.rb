Mercator::Application.configure do
  config.cache_classes = true
  config.eager_load = true

  # otherwise it's debug, because we are not in production
  config.log_level = :info

  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.serve_static_files = false
  config.assets.compress = true
  config.assets.compile = false
  config.assets.digest = true

  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify

  ActionMailer::Base.smtp_settings = { domain: CONFIG[:smtp_domain],
                                       enable_starttls_auto: false }

  config.middleware.use ExceptionNotification::Rack,
  :email => { email_prefix: "[MERCATOR - " + CONFIG[:system_name] + "] ",
              sender_address: %{"notifier" <error@mercator.informatom.com>},
              exception_recipients: CONFIG[:exception_notification] }
end