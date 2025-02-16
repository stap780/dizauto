source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.0'

gem 'acts_as_list'
gem 'addressable'
gem 'audited'
gem 'audited-ui'
gem 'aws-sdk-s3'
gem 'barby'
gem 'bootsnap', require: false
gem 'cancancan'
gem 'chunky_png'
gem 'caxlsx'
gem 'caxlsx_rails'
gem 'combine_pdf'
gem 'cssbundling-rails'
gem 'devise'
gem 'erb-formatter', '~> 0.4.3'
gem 'image_processing', '~> 1.2'
gem 'liquid'

gem 'rails', '~> 7.1.1'
gem 'redis', '~> 4.0'

gem 'pg', '~> 1.1'
gem 'puma'

gem 'jbuilder'
gem 'jsbundling-rails'

gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'sidekiq'
gem 'sidekiq-scheduler'
gem 'sprockets-rails'
gem 'stimulus-rails'

gem 'high_voltage', '~> 3.1'

gem 'will_paginate', '~> 3.3'
gem 'will_paginate-bootstrap-style'

gem 'rack-cors'
gem 'ransack'
gem 'recaptcha'
gem 'requestjs-rails'
gem 'rest-client'
gem 'roo'
gem 'roo-xls'


gem 'insales_api', github: 'stap780/insales_api'
gem 'kaminari'
gem 'noticed', '~> 2.1'

gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'

gem 'telegram-bot-ruby', '~> 2.1'


group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'standard'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'

  gem 'letter_opener'

  gem 'capistrano', require: false
  gem 'capistrano3-puma', github: 'seuros/capistrano-puma'
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  # gem 'capistrano-rails-console', require: false
  gem 'capistrano-sidekiq', require: false
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'selenium-webdriver'
  # gem "webdrivers"
end
