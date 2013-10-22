source 'https://rubygems.org'

gem 'rails', '3.2.14'

gem 'pg', '~> 0.17.0'

gem 'jquery-rails', '~> 2.3.0'

gem "hobo", "= 2.0.1"
gem "quiet_assets", :group => :development
gem "will_paginate", :git => "git://github.com/Hobo/will_paginate.git"
gem "hobo_bootstrap", "2.0.1"
gem "hobo_jquery_ui", "2.0.1"
gem "hobo_bootstrap_ui", "2.0.1"
gem "jquery-ui-themes", "~> 0.0.4"
gem 'jquery-datatables-rails', git: 'git://github.com/rweng/jquery-datatables-rails.git'
gem "hobo_data_tables", :git => "git://github.com/Hobo/hobo_data_tables.git"
gem "less-rails"

gem "paper_trail"
gem "ancestry"

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'therubyracer', :platforms => :ruby
  gem 'uglifier', '>= 1.0.3'
end

group :development, :test  do
  gem 'thin' #replacement for webrick
  gem 'debugger', '~> 1.6.2'
  gem 'rspec-rails', '~> 2.14.0'
  gem 'factory_girl_rails', '~> 4.2.1'
end

group :test do
  gem 'faker', '~> 1.2.0'
  gem 'capybara', '~> 2.1.0'
  gem 'database_cleaner', '~> 1.2.0'
  gem 'launchy', '~> 2.3.0'
  gem 'selenium-webdriver', '~> 2.35.1'
end
