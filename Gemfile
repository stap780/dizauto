source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.0"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.1"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

gem "pg", "~> 1.1"
gem "puma"

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"
gem "redis", "~> 4.0"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.2"
gem "devise"
gem "sidekiq"
gem "sidekiq-scheduler"
gem "high_voltage", "~> 3.1"
gem "cancancan"
gem "ransack"
gem "will_paginate", "~> 3.3"
gem "acts_as_list"
gem "requestjs-rails"
gem "erb-formatter", "~> 0.4.3"
gem "liquid"
gem "caxlsx"
gem "caxlsx_rails"
gem "roo"
gem "roo-xls"

gem "audited"
gem "audited-ui"
gem 'kaminari'

gem "barby"
gem "wicked_pdf"
gem "wkhtmltopdf-binary"
gem "combine_pdf"
gem "recaptcha"
gem "addressable"
gem "rest-client"
gem "aws-sdk-s3"
gem "rack-cors"
gem "noticed", "~> 2.1"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "standard"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  gem "letter_opener"

  gem "capistrano", "~> 3.10", require: false
  gem "capistrano-rails", "~> 1.6", require: false
  gem "capistrano-rvm", require: false
  gem "capistrano3-puma", github: "seuros/capistrano-puma"
  # gem 'capistrano-rails-console', require: false
  gem "capistrano-sidekiq", require: false
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  # gem "webdrivers"
end
