source 'https://rubygems.org'

gem 'rails', '3.2.16'                               # Web applitation framework
gem 'pg', '~> 0.17.0'                               # Postgres data base
gem 'mysql2'                                        # MYSQL Database Adapter
gem 'jquery-rails', '~> 2.3.0'                      # JQuery asset handling

gem "hobo", "= 2.0.1"                               # web application meta framework
gem "will_paginate", :git => "git://github.com/Hobo/will_paginate.git"
                                                    # pagination support
gem "hobo_bootstrap", "2.0.1"                       # Twitter Bootstrap asset handling
gem "hobo_jquery_ui", "2.0.1"                       # JQuery UI asser handling
gem "hobo_bootstrap_ui", "2.0.1"                    # additional Bootstrap features
gem "jquery-ui-themes", "~> 0.0.4"                  # JQury Ui theming
gem "paperclip"                                     # attachment handling
gem 'hobo_paperclip', :git => "git://github.com/Hobo/hobo_paperclip.git", :branch => "master"
                                                    # Paperclip Hobo integration
gem "ckeditor", :git => "git://github.com/galetahub/ckeditor.git"
gem "hobo_ckeditor"                                 # CKEditor integration
gem "paper_trail"                                   # historization on object level
gem "ancestry"                                      # hierarchical data structures
gem "acts_as_list"                                  # list structures
gem "messengerjs-rails"                             # Messenger Javascript Framework assets
gem 'traco'                                         # model attribute translations

group :assets do
  gem 'sass-rails',   '~> 3.2.3'                    # Sass support
  gem "less-rails"                                  # Less support
  gem 'coffee-rails', '~> 3.2.1'                    # Coffeescript support
  gem 'therubyracer'                                # Javascript engine
  gem 'uglifier', '>= 1.0.3'                        # Code minimizer
  gem 'turbo-sprockets-rails3'                      # Only compile assets that have changed
end

group :development, :test  do
  gem 'thin'                                        # web server, replacement for webrick
  gem 'debugger', '~> 1.6.2'                        # Command line debugger
  gem "quiet_assets"                                # leaner log output
  gem "require_all"
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