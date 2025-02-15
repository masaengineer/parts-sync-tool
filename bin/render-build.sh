#!/usr/bin/env bash
# exit on error
set -o errexit

# Install dependencies
bundle install
yarn install

# Build assets
yarn build
yarn build:css

# Setup database
bundle exec rails db:migrate
bundle exec rails db:seed

# Clear cache
bundle exec rails tmp:clear
bundle exec rails log:clear
bundle exec rails assets:clean
