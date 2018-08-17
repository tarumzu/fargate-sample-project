#!/bin/bash
ln -sf /dev/stdout /usr/src/app/log/${RAILS_ENV}.log
RAILS_ENV=${RAILS_ENV} bundle exec rails db:create
RAILS_ENV=${RAILS_ENV} bundle exec rails db:migrate
# RAILS_ENV=${RAILS_ENV} bundle exec rails db:seed_fu
RAILS_ENV=${RAILS_ENV} bundle exec pumactl -F config/puma.rb start
