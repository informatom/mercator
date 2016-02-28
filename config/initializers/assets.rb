Rails.application.config.assets.version = '1.0'

# Rails.application.config.assets.paths << Emoji.images_path

# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

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