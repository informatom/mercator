source 'https://rubygems.org'

gem 'rails', '4.0.9'                                  # Web applitation framework
gem 'mysql2'                                          # MYSQL Database Adapter
gem 'tiny_tds'                                        # A modern, simple and fast FreeTDS library for Ruby using DB-Library
gem 'activerecord-sqlserver-adapter', '~> 4.0'        # MSSQL server database connector

gem 'jquery-rails', '~> 2.3.0'                        # JQuery asset handling
gem 'jquery-ui-rails'
gem "protected_attributes"
gem 'valvat'                                          # European Vat Number Validation

# gem 'hobo', :path => '../hobo'                      # web application meta framework locally installed
# gem "hobo", "= 2.1.1"                               # web application meta framework from Rubygems
gem 'hobo', :git => 'https://github.com/Hobo/hobo.git'  # web application meta framework from Github

gem "hobo_will_paginate"                              # pagination support

# gem "hobo_bootstrap", "2.1.1"                         # Twitter Bootstrap asset handling
gem "hobo_bootstrap", path:"vendor/gems/hobo_bootstrap"

gem 'bootswatch-rails'                                # Bootstrap Bootswatch themes
gem "hobo_jquery_ui", "2.1.1"                         # JQuery UI asser handling

# gem "hobo_bootstrap_ui", "2.1.1"                      # additional Bootstrap features
gem "hobo_bootstrap_ui", path:"vendor/gems/hobo_bootstrap_ui"
gem "bootstrap-slider-rails"

gem "jquery-ui-themes", "~> 0.0.4"                    # JQury Ui theming

gem "paperclip"                                       # attachment handling
gem 'hobo_paperclip', :git => "https://github.com/Hobo/hobo_paperclip.git", :branch => "master"
                                                      # Paperclip Hobo integration
gem "ckeditor", :git => "https://github.com/galetahub/ckeditor.git"
                                                      # WYSIWYG Editor
gem "hobo_ckeditor"                                   # CKEditor integration
gem "paper_trail", '~> 3.0.0'                         # historization on object level
gem "ancestry"                                        # hierarchical data structures
gem "acts_as_list"                                    # list structures
gem 'acts-as-taggable-on', '~> 3.4'                   # tagging

gem "messengerjs-rails"                               # Messenger Javascript Framework assets
gem 'traco'                                           # model attribute translations
gem 'turbolinks'                                      # Exchanges only body content lia ajax call on reload
gem 'jbuilder', '~> 1.2'                              # a simple DSL for declaring JSON structures

gem 'roo'                                             # more sophisticated Excel spreadsheet generation
gem 'sass-rails', '~> 4.0.0'                          # Sass support
gem "less-rails"                                      # Less support
gem 'coffee-rails', '~> 4.0.0'                        # Coffeescript support
gem 'therubyracer', :platforms => :ruby               # Javascript engine
gem 'uglifier', '>= 1.3.0'                            # Code minimizer

gem "font-awesome-rails"                              # Font awesome icon font
gem "squeel"                                          # active record improvements
gem 'whenever', :require => false                     # cronjob management
gem 'private_pub'                                     # Private Pub Sub System using Faye
gem 'wicked_pdf'                                      # Pdf Generation
gem 'wkhtmltopdf-binary'
gem "searchkick"                                      # Elastic Search integration
gem 'delayed_job_active_record'                       # asynchronous Jobs
gem "daemons"                                         # to daemonize delayed_job
gem "delayed_job_web"                                 # Web interface for delayed job

gem "holidays"                                        # Determine if there is a public holiday
gem "naught"                                          # Null Object library

group :production do
  gem "mercator_icecat", path:"vendor/engines/mercator_icecat"   # Engine for importing Icecat Data
  gem "mercator_mpay24", path:"vendor/engines/mercator_mpay24"   # Engine for MPay24 interface
  gem "mercator_mesonic", path:"vendor/engines/mercator_mesonic" # Engine for integrating Mesonic ERP System
  gem "mercator_bechlem", path:"vendor/engines/mercator_bechlem" # Engine for integrating Mesonic ERP System
  gem "mercator_legacy_importer", path:"vendor/engines/mercator_legacy_importer"# Engine for importing Legacy Data
end

gem 'try_to'                                          # checks for methods existance and avoids dumps
gem 'friendly_id', '~> 5.0.0'                         # Friendlier URLs for webpages
gem 'codemirror-rails'                                # Code Editor

gem "ember-rails"                                     # Ember - Rails Integration
gem "ember-source"                                    # Ember Asset Handling
gem "active_model_serializers"                        # JSON serialization, easy configuration for Ember

gem 'exception_notification'                          # exception_notification via e-mail
gem 'awesome_print'

group :development, :test  do
#  gem "puma"                                          # web server, replacement for webrick
  gem 'byebug'                                        # Command line debugger
  gem "quiet_assets"                                  # leaner log output
  gem "better_errors"                                 # Debug messages im Browser
  gem "binding_of_caller"                             # Repl for better_errors
  gem "railroady"                                     # ER-Diagrams
# gem 'rack-mini-profiler'                            # Performance Testing
# gem 'dryml-firemarker', :require => 'dryml13-firemarker'
                                                      # DRYML Debugger
  gem 'capistrano'                                    # Deployment automation
  gem 'capistrano-rails'                              # Rails specific tasks
  gem 'rvm-capistrano'                                # Capistrano rvm integration
end

group :test do
  gem 'rspec-rails', '~> 2.14.0'                      # unit testing framework
  gem 'factory_girl_rails', '~> 4.2.1'                # factories
  gem 'faker', '~> 1.2.0'                             # data faker
  gem 'capybara', '~> 2.1.0'                          # behaviour testing framework
  gem 'database_cleaner', '~> 1.2.0'                  # database cleaner
  gem 'launchy', '~> 2.3.0'                           # browser launcher
  gem 'selenium-webdriver', '~> 2.35.1'               # front end testing framework
  gem 'shoulda'                                       # additional matchers
end

gem "hobo_clean_admin", "2.1.1"