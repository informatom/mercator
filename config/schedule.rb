# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

set :output, "/var/rails/%enter_app_puth_here%/log/cron.log"
set :path, "/var/rails/%enter_app_path_here%%"

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

every 1.day, :at => '5:00 am' do
  rake "rake mesonic:users:update_erp_account_nrs"
end

every 1.day, :at => '5:30 am' do
  rake "icecat:metadata:daily_update"
end

every :sunday, :at => "10:00 pm" do
  rake "icecat:metadata:weekly_full_update"
end

every :weekday, :at => '8:30 am' do
  runner "User.no_sales_logged_in"
end

# whenever
# Learn more: http://github.com/javan/whenever