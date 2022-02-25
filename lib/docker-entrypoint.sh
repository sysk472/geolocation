#!/bin/sh

set -e

if [ -f /app/tmp/pids/server.pid ]; then
  rm /app/tmp/pids/server.pid
fi


bundle exec rake db:migrate 2>/dev/null || bundle exec rake db:setup
RAILS_ENV=test bundle exec rake db:create && RAILS_ENV=test rake db:migrate
exec bundle exec "$@"