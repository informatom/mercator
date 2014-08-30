Mercator::Application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.serve_static_assets = false
  config.assets.compress = true
  config.assets.compile = true
  config.assets.digest = true

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )

  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify

  ActionMailer::Base.smtp_settings = {
    :domain => CONFIG[:smtp_domain],
    :enable_starttls_auto => false
  }

  config.ember.variant = :production

  config.middleware.use ExceptionNotification::Rack,
  :email => { :email_prefix => "[MERCATOR - " + CONFIG[:system_name] + "] ", :sender_address => %{"notifier" <error@mercator.informatom.com>},
              :exception_recipients => CONFIG[:exception_notification]}
end