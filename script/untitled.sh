#!/bin/sh

# HAS 20140117 switches user to rails-user
export RAILS_ENV=production
exec 2>/dev/null
exec setuidgid rails /var/rails/mercator/script/delayed_job run