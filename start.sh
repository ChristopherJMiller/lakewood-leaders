#!/bin/sh
rake db:create db:migrate
RAILS_ENV=production script/delayed_job start
puma -C config/puma.rb
