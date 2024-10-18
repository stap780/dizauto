source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.0"

gem "rails", "~> 7.1.1"

gem "sprockets-rails"

gem "pg", "~> 1.1"
gem "puma"

gem "jsbundling-rails"

gem "turbo-rails"

gem "stimulus-rails"

gem "cssbundling-rails"

gem "jbuilder"
gem "redis", "~> 4.0"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

gem "bootsnap", require: false

gem "image_processing", "~> 1.2"
gem "devise"
gem "sidekiq"
gem "sidekiq-scheduler"
gem "high_voltage", "~> 3.1"
gem "cancancan"
gem "ransack"
gem "will_paginate", "~> 3.3"
gem 'will_paginate-bootstrap-style'

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
gem 'insales_api', github: "stap780/insales_api"


group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "standard"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  gem "letter_opener"

  gem "capistrano", require: false
  gem "capistrano-rails", require: false
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
