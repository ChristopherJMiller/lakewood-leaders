#!/bin/sh
rake db:create db:migrate
unicorn -E production -p 3000 -c ./config/unicorn.rb
