Mercator::Application.configure do
  config.cache_classes = true

# HAS: 20131219 according to deprecation warning on update to Rails 4
  config.eager_load = true

  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.serve_static_assets = false
  config.assets.compress = true
  config.assets.compile = false
  config.assets.digest = true

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  Rails.application.config.assets.precompile += [ 'admin.css', 'admin.js', 'contentmanager.css',
    'contentmanager.js', 'contracting.css', 'contracting.js', 'front.css', 'front.js',
    'productmanager.css', 'productmanager.js', 'sales.css', 'sales.js' ]

  ActionMailer::Base.smtp_settings = {
    :domain => CONFIG[:smtp_domain],
    :enable_starttls_auto => false
  }

  config.ember.variant = :production

  config.middleware.use ExceptionNotification::Rack,
  :email => { :email_prefix => "[MERCATOR - " + CONFIG[:system_name] + "] ", :sender_address => %{"notifier" <error@mercator.informatom.com>},
              :exception_recipients => CONFIG[:exception_notification]}
end