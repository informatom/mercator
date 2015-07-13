Mercator::Application.configure do
  config.cache_classes = true
  config.eager_load = true

  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.serve_static_assets = false
  config.assets.compress = true
  config.assets.compile = false
  config.assets.digest = true

  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify

  Rails.application.config.assets.precompile += [
    'admin.css',
    'admin.js',
    'contentmanager.css',
    'contentmanager.js',
    'contracting.css', 'contracting.js',
    'front.css',
    'front-pdf.css',
    'front.js',
    'productmanager.css',
    'productmanager.js',
    'sales.css',
    'sales.js',
    'contentmanager/index/index.js',
    'productmanager/front/index.js',
    'productmanager/price_manager/index.js',
    'productmanager/property_manager/index.js',
    'productmanager/relation_manager/index.js',
    'contracting/contracts/index.js',
    'contracting/contractitems/index.js',
    'contracting/consumableitems/index.js',
    'i18n.js',
    'i18n/cm.js',
    'i18n/pm.js',
    'i18n/con.js',
    'jquery.js',
    'jquery-migrate.js',
    'podlove-web-player-rails/index.js',
    "ckeditor/*",
    'application/EventEmitter.min.js',
    'application/palava.js']

  ActionMailer::Base.smtp_settings = { domain: CONFIG[:smtp_domain],
                                       enable_starttls_auto: false }

  config.middleware.use ExceptionNotification::Rack,
  :email => { email_prefix: "[MERCATOR - " + CONFIG[:system_name] + "] ",
              sender_address: %{"notifier" <error@mercator.informatom.com>},
              exception_recipients: CONFIG[:exception_notification] }
end