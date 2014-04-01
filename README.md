,# Welcome to Mercator

The Austrian Guided Selling Solution based on Hobo on Ruby on Rails

Mercator is a guided selling web application written using the Hobo web application framework.

## Dependencies

First of: There are lots of dependencies as we aim to write as little code as possible

* Hobo. Find more about Hobo including a full book on Hobo at http://www.hobocentral.net/
* Ruby on Rails. See http://rubyonrails.org/ for more.
* Ruby. https://www.ruby-lang.org/de/about/
* PostgresQL (The application should run on MySQL as well, but that is not supported in nay way)
* FreeTDS:
```bash
sudo apt-get install freetds-dev freetds-bin tdsodbc unixodbc unixodbc-dev
```

FIXME! Links, all below me
FIXME! What is guided selling

## Getting Started

For ad development scenario or for testing out the applacation a somewhat slower but still
reasonably fast development instace can be fired up pretty fast

1. Install Ruby. In Linux environments we recommend rvm for doing this. See https://rvm.io/rvm/install for details
2. Install all gems needed by running <tt>bundle install</tt>
3. Create a database mercator_production using <tt>rake db:create</tt>
4.  Whenever Gem needs for RVM-compatibility ~/.rvmrc with content rvm_trust_rvmrcs_flag=1
5. Start up your Server <tt>rails s</tt>

Your Mercator is now running and fully functional!

5. Visit <tt>http://localhost:3000</tt>
6. The first user registered will have administrator priviliges assigned
7. The second user registered will have sales priviliges assigned
8. The third and any further users registered will have customer priviliges assigned

FIXME! Second user should be sales guy

## Installing Mesonic Integration

1. Put in your Gemfile
'''ruby
gem "mercator_mesonic"
'''
2 Get all migrations into your app
'''ruby
rake mercator_mesonic:install:migrations
'''

## Useful Job Declarations

#### Deleting deprecated Orders
0 * * * * /bin/bash -l -c 'cd /var/rails/mercator && script/rails runner -e production '\''Order.cleanup_deprecated'\'' >> /var/rails/mercator/log/cron.log 2>&1'
#### Deleting deprecated Users
10 * * * * /bin/bash -l -c 'cd /var/rails/mercator && script/rails runner -e production '\''User.cleanup_deprecated'\'' >> /var/rails/mercator/log/cron.log 2>&1'


## Sources

* Audio sample Big Ben from Freesound.org: http://www.freesound.org/people/hyderpotter/sounds/80290/
