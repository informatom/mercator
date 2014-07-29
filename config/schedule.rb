# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

set :output, "/var/rails/mercator/log/cron.log"
set :path, "/var/rails/mercator"

every 1.hour do
  runner "Order.cleanup_deprecated"
  runner "User.cleanup_deprecated"
end

every 1.day, :at => '3:30 am' do
  rake "bechlem:import"
end

every 1.day, :at => '4:30 am' do
  rake "webartikel:update"
end

every 1.day, :at => '5:30 am' do
  rake "icecat:metadata:daily_update"
end

# whenever
# Learn more: http://github.com/javan/whenever