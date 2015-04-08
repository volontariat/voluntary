source "http://rubygems.org"

# Declare your gem's dependencies in voluntary.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# core
gem 'rack-cors', '~> 0.2.4', require: 'rack/cors'
gem 'thin', '~> 1.3.1', require: false

# model 
gem 'settingslogic', git: 'https://github.com/binarylogic/settingslogic.git'

# view 
gem 'acts_as_markup', git: 'git://github.com/vigetlabs/acts_as_markup.git'
gem 'recaptcha', require: 'recaptcha/rails'

# queue

gem 'sinatra', require: false

# URIs and HTTP

gem 'addressable', '~> 2.2', require: 'addressable/uri'

# test

gem 'jasmine', git: 'https://github.com/pivotal/jasmine-gem.git'

# misc

# invalid byte sequence in US-ASCII on production
#  gem 'markerb', git: 'https://github.com/plataformatec/markerb.git'

# view
gem "will_paginate", github: 'mislav/will_paginate'

group :development do
  gem 'mysql2', '~> 0.3.13'
  gem 'linecache', '0.46', platforms: :mri_18
  gem 'capistrano', '~> 2.15.5', require: false
  gem 'capistrano_colors', '~> 0.5.5', require: false
  gem 'capistrano-ext', '~> 1.2.1', require: false
  gem 'yard', '~> 0.7', require: false
end

group :test do
  gem 'cucumber-rails', '~> 1.3.0', require: false
  gem 'rspec-instafail', '~> 0.2.4', require: false
  gem 'webmock', '~> 1.8.11', require: false
  gem 'simplecov', '~> 0.7.1', require: false
end

group :test, :cucumber do
  gem 'codeclimate-test-reporter', require: nil
end

group :development, :test do
  gem 'debugger', platforms: :mri_19
  gem 'ruby-debug', '~> 0.10.4', platforms: :mri_18
end

group :assets do
  gem 'therubyracer', '~> 0.12.0', platforms: :ruby
  
  # asset_sync is required as needed by application.rb
  gem 'asset_sync', '~> 0.5.0', require: nil
end