source 'https://rubygems.org'

gem 'rails', '4.0.2'                                # Web applitation framework
gem 'mysql2'                                        # MYSQL Database Adapter
gem 'jquery-rails'                                  # JQuery asset handling

gem "protected_attributes"

# gem 'hobo', :path => '../hobo'                      # web application meta framework locally installed
# gem "hobo", "= 2.1.0.pre4"                          # web application meta framework from Rubygems
gem 'hobo', :git => 'git://github.com/Hobo/hobo.git'  # web application meta framework from Github

gem "hobo_will_paginate"                            # pagination support
gem "hobo_bootstrap", "2.1.0.pre4"                  # Twitter Bootstrap asset handling
gem 'bootswatch-rails'                              # Bootstrap Bootswatch themes
gem "hobo_jquery_ui", "2.1.0.pre4"                  # JQuery UI asser handling
gem "hobo_bootstrap_ui", "2.1.0.pre4"               # additional Bootstrap features
gem "jquery-ui-themes", "~> 0.0.4"                  # JQury Ui theming
gem "paperclip"                                     # attachment handling
gem 'hobo_paperclip', :git => "git://github.com/Hobo/hobo_paperclip.git", :branch => "master"
                                                    # Paperclip Hobo integration
gem "ckeditor", :git => "git://github.com/galetahub/ckeditor.git"
                                                    # WYSIWYG Editor
gem "hobo_ckeditor"                                 # CKEditor integration
gem "paper_trail", '~> 3.0.0'                       # historization on object level
gem "ancestry"                                      # hierarchical data structures
gem "acts_as_list"                                  # list structures
gem "messengerjs-rails"                             # Messenger Javascript Framework assets
gem 'traco'                                         # model attribute translations
gem 'turbolinks'                                    # Exchanges only body content lia ajax call on reload
gem 'jbuilder', '~> 1.2'                            # a simple DSL for declaring JSON structures

gem 'roo'                                           # more sophisticated Excel spreadsheet generation
gem 'sass-rails', '~> 4.0.0'                        # Sass support
gem "less-rails"                                    # Less support
gem 'coffee-rails', '~> 4.0.0'                      # Coffeescript support
gem 'therubyracer', :platforms => :ruby             # Javascript engine
gem 'uglifier', '>= 1.3.0'                          # Code minimizer

gem "font-awesome-rails"                            # Font awesome icon font
gem "squeel"                                        # active record improvements
gem 'whenever', :require => false                   # cronjob management
gem 'private_pub'                                   # Private Pub Sub System using Faye

group :development, :test  do
  gem 'thin'                                        # web server, replacement for webrick
  gem 'debugger', '~> 1.6.5'                        # Command line debugger
  gem "quiet_assets"                                # leaner log output
  gem "require_all"                                 # requiring a full directory
  gem "better_errors"                               # Debug messages im Browser
  gem "binding_of_caller"                           # Repl for better_errors
#  gem 'rack-mini-profiler'                          # Performance Testing
#  gem 'dryml-firemarker', :require => 'dryml13-firemarker' # DRYML Debugger
end

group :test do
  gem 'rspec-rails', '~> 2.14.0'                    # unit testing framework
  gem 'factory_girl_rails', '~> 4.2.1'              # factories
  gem 'faker', '~> 1.2.0'                           # data faker
  gem 'capybara', '~> 2.1.0'                        # behaviour testing framework
  gem 'database_cleaner', '~> 1.2.0'                # database cleaner
  gem 'launchy', '~> 2.3.0'                         # browser launcher
  gem 'selenium-webdriver', '~> 2.35.1'             # front end testing framework
  gem 'shoulda'                                     # additional matchers
end