# Mercator

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
7. The second and any further users registered will have customer priviliges assigned

## Setting up constants

The following constants have to be set in the Administration Area (http://yourdomain.com/admin/constants)
* delivery_times_de, delivery_times_en: Comma seperated list of texts used for available delivery times
* shipping_cost_article: name of the article used for shipping costs
* site_name: text string, used for title-tags in the application
* shop_domain, cms_domain: Damain names for the shop and the cms area of the application, respectively. They have to be porvided including subdomais, but without protocol (e.g. mercator.informatom.com). They can be identical.
* fifo: storage strategy, either true or false (as text strings). If false is given, lifo is used.

## Add-Ons

Several Gems are installed, which are non-mandatory add-ons.

```ruby
gem "mercator_mesonic"
gem "mercator_legacy_importer"
gem "mercator_bechlem"
gem "mercator_icecat"
```

Get all migrations from the gems into your application:
```ruby
rake mercator_mesonic:install:migrations
```

## Installing Elasticsearch

Download and install the Public Signing Key
```bash
wget -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add -
```
Add the following to your /etc/apt/sources.list to enable the repository
```bash
deb http://packages.elasticsearch.org/elasticsearch/1.1/debian stable main
```
und then run
```bash
apt-get update
sudo apt-get install elasticsearch
```

Installing Browser Plugin for Development
```bash
sudo /usr/share/elasticsearch/bin/plugin -install mobz/elasticsearch-head
```

Autostart Service
```bash
sudo update-rc.d elasticsearch defaults 95 10
sudo /etc/init.d/elasticsearch start
```

### Icecat Integration

If Using MercatorIcecat for Icecat Integration you need one import like
  <include src="../../../vendor/engines/mercator_icecat/app/views/taglibs/admin/*"/>
in admin.dryml per Subsite.

## Useful Job Declarations

#### Deleting deprecated Orders hourly
```bash
0 * * * * /bin/bash -l -c 'cd /var/rails/mercator && script/rails runner -e production '\''Order.cleanup_deprecated'\'' >> /var/rails/mercator/log/cron.log 2>&1'
```
#### Deleting deprecated Users hourly
```bash
10 * * * * /bin/bash -l -c 'cd /var/rails/mercator && script/rails runner -e production '\''User.cleanup_deprecated'\'' >> /var/rails/mercator/log/cron.log 2>&1'
```
#### Updating Inventories daily
```bash
30 4 * * * /bin/bash -l -c 'cd /var/rails/mercator && RAILS_ENV=production bundle exec rake webartikel:update --silent >> /var/rails/mercator/log/cron.log 2>&1'
```

## Sources

* Audio sample Big Ben from Freesound.org: http://www.freesound.org/people/hyderpotter/sounds/80290/
