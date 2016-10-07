#!/bin/sh
rake db:create db:migrate
#RAILS_ENV=production bin/delayed_job start
puma -C config/puma.rb
