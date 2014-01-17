# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

set :output, "/var/rails/mercator/log/cron.log"

  every 15.minutes do
   runner "Order.cleanup_deprecated"
 end

# Learn more: http://github.com/javan/whenever
